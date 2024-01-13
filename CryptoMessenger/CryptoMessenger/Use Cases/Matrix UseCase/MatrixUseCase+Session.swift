import Foundation
import MatrixSDK

extension MatrixUseCase {
    func observeSessionToken() {
        NotificationCenter.default
            .addObserver(
                self,
                selector: #selector(tokenRefreshed),
                name: .didRefreshToken,
                object: nil
            )
    }
    
    @objc func tokenRefreshed() {
        guard let apiToken: String = keychainService.apiAccessToken,
              let userId: String = userSettings.userId,
              let deviceId: String = keychainService.deviceId else {
            return
        }
        let homeServer = config.matrixURL
        loginByJWT(
            token: apiToken,
            deviceId: deviceId,
            userId: userId,
            homeServer: homeServer
        ) { result in
            if case .success = result {
                debugPrint("MatrixUseCase tokenRefreshed loginByJWT TOKEN REFRESHED")
            } else {
                debugPrint("MatrixUseCase tokenRefreshed loginByJWT TOKEN NOT REFRESHED")
            }
        }
    }

    func loginByJWT(
        token: String,
        deviceId: String,
        userId: String,
        homeServer: URL,
        completion: @escaping EmptyFailureBlock<AuraMatrixCredentials>
    ) {
        matrixService.updateClient(with: homeServer)
        matrixService.loginByJWT(
            token: token,
            deviceId: deviceId,
            userId: userId,
            homeServer: homeServer
        ) { [weak self] result in
            self?.handleLogin(response: result, completion: completion)
        }
    }

    func handleLogin(
        response: Result<MXCredentials, Error>,
        completion: @escaping EmptyFailureBlock<AuraMatrixCredentials>
    ) {
        guard case .success(let credentials) = response else {
            matrixService.updateState(with: .failure(.loginFailure))
            completion(.failure)
            return
        }

        save(credentials: credentials)
        matrixService.updateService(credentials: credentials)

        matrixService.initializeSessionStore { [weak self] result in
            guard case .success = result else {
                self?.matrixService.updateState(with: .failure(.loginFailure))
                completion(.failure)
                return
            }
            self?.matrixService.startSession { result in
                guard case .success = result, let userId = credentials.userId else {
                    self?.matrixService.updateState(with: .failure(.loginFailure))
                    completion(.failure)
                    return
                }

                self?.matrixService.updateState(with: .loggedIn(userId: userId))
                self?.matrixService.updateUnkownDeviceWarn(isEnabled: false)
                self?.matrixService.startListeningForRoomEvents()
                self?.subscribeToEvents()
                self?.serverSyncWithServerTimeout()

                guard let homeServer = credentials.homeServer,
                      let userId = credentials.userId,
                      let accessToken = credentials.accessToken,
                      let deviceId = credentials.deviceId else {
                    completion(.failure)
                    return
                }
                let auraMxCredentials = AuraMatrixCredentials(
                    homeServer: homeServer,
                    userId: userId,
                    accessToken: accessToken,
                    deviceId: deviceId
                )
                completion(.success(auraMxCredentials))
            }
        }
    }

    func logout(completion: @escaping (Result<MatrixState, Error>) -> Void) {
        matrixService.logout { [weak self] in
            completion($0)
            self?.closeSession()
        }
    }

    func closeSession() {
        debugPrint("MATRIX DEBUG MatrixUseCase closeSession")
        matrixService.closeSessionAndClearData()
    }
}
