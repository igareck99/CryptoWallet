import Foundation
import MatrixSDK

extension MatrixUseCase {
    
    func observeLoginState() {
        NotificationCenter.default
            .addObserver(
                self,
                selector: #selector(userDidLoggedIn),
                name: .userDidLoggedIn,
                object: nil
            )
    }
    
    @objc func userDidLoggedIn() {
        matrixService.updateState(with: .loggedIn(userId: matrixService.getUserId()))
        updateCredentialsIfAvailable()
    }
    
    // TODO: Отрефачить логику входа по пин коду
    func updateCredentialsIfAvailable() {
        guard let credentials = retrievCredentials() else { return }
        matrixService.updateService(credentials: credentials)
        matrixService.initializeSessionStore { [weak self] result in
            guard case .success = result else {
                self?.matrixService.updateState(with: .failure(.loginFailure))
                return
            }
            self?.matrixService.startSession { result in
                guard case .success = result, let userId = credentials.userId else {
                    self?.matrixService.updateState(with: .failure(.loginFailure))
                    return
                }
                self?.matrixService.configureFetcher()
                self?.matrixService.updateState(with: .loggedIn(userId: userId))
                self?.matrixService.updateUnkownDeviceWarn(isEnabled: false)
                self?.matrixService.startListeningForRoomEvents()
                self?.subscribeToEvents()
            }
        }
    }

    func save(credentials: MXCredentials) {
        debugPrint("MATRIX DEBUG MatrixUseCase save(credentials: MXCredentials) \(credentials)")
        // MARK: - Пока оставил для отладки
//        guard
//            let userId = credentials.userId,
//            let homeServer = credentials.homeServer,
//            let accessToken = credentials.accessToken,
//            let deviceId = credentials.deviceId else {
//            return
//        }

//        userSettings.userId = userId
//        keychainService.homeServer = homeServer
//        keychainService.accessToken = accessToken
//        keychainService.deviceId = deviceId
        debugPrint("Credetials saved")
    }

    func clearCredentials() {
        debugPrint("Credetials clearCredentials START")
        keychainService.removeObject(forKey: .homeServer)
        keychainService.removeObject(forKey: .accessToken)
        keychainService.removeObject(forKey: .apiRefreshToken)
        keychainService.removeObject(forKey: .deviceId)
        userSettings.removeObject(forKey: .userId)
        debugPrint("Credetials clearCredentials END")
    }

    func retrievCredentials() -> MXCredentials? {
        guard
            let userId: String = userSettings.userId,
            let homeServer: String = keychainService.homeServer,
            let accessToken: String = keychainService.accessToken,
            let deviceId: String = keychainService.deviceId
        else {
            return nil
        }
        let credentials = MXCredentials(
            homeServer: homeServer,
            userId: userId,
            accessToken: accessToken
        )
        credentials.deviceId = deviceId
        return credentials
    }
}
