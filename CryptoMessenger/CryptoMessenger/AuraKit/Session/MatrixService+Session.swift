import Foundation
import MatrixSDK

typealias LoginCompletion = GenericBlock<Result<MXCredentials, Error>>

// MARK: - Session

extension MatrixService {

	var matrixSession: MXSession? { session }

	func initializeSessionStore(completion: @escaping (EmptyResult) -> Void) {
        debugPrint("MATRIX DEBUG MatrixService initializeSessionStore")
		session?.setStore(fileStore) { response in
			switch response {
			case .failure(let error):
				debugPrint("Failed setting store with error: \(error)")
				completion(.failure)
			case .success:
				completion(.success)
			}
		}
	}

	func startSession(completion: @escaping (Result<MatrixState, MXErrors>) -> Void) {
        debugPrint("MATRIX DEBUG MatrixService startSession")
		session?.start { [weak self] response in
			switch response {
			case .failure(_):
				completion(.failure(.startSessionFailure))
			case .success:
				guard let userId = self?.credentials?.userId
				else { completion(.failure(.userIdRetrieve)); return }
				completion(.success(.loggedIn(userId: userId)))
			}
		}
	}

    func loginByJWT(
        token: String,
        deviceId: String,
        userId: String,
        homeServer: URL,
        completion: @escaping LoginCompletion
    ) {
        loginState = .authenticating
        let parameters: [String: Any] = [
            "type": "org.matrix.login.jwt",
            "token": token,
            "device_id": deviceId
        ]
        debugPrint("parameters: \(parameters)")
        debugPrint("parameters:")
        client?.login(parameters: parameters) { [weak self] response in
            debugPrint("\(response)")
            debugPrint("response")

            guard
                case let .success(dict) = response,
                let model = Parser.parse(dictionary: dict, to: AuthMatrixJWTResponse.self),
                let accessToken = model.accessToken,
                let mUserId = model.userId,
                let mDeviceId = model.deviceId
            else {
                completion(.failure(MXErrors.loginFailure))
                return
            }
            let credentials = MXCredentials(
                homeServer: homeServer.absoluteString,
                userId: mUserId,
                accessToken: accessToken
            )
            credentials.deviceId = mDeviceId
            self?.loginState = .loggedIn(userId: credentials.userId ?? "")
            completion(.success(credentials))
        }
    }

	func login(
		userId: String,
		password: String,
		homeServer: URL,
		completion: @escaping LoginCompletion
	) {
        debugPrint("MATRIX DEBUG MatrixService login()")
		loginState = .authenticating
		client?.login(username: userId, password: password) { [weak self] response in
            debugPrint("MATRIX DEBUG MatrixService client?.login response: \(response)")
			switch response {
			case .failure(let error):
				self?.loginState = .failure(.loginFailure)
				completion(.failure(error))
			case let .success(credentials):
				self?.loginState = .loggedIn(userId: credentials.userId ?? "")
				completion(.success(credentials))
			}
		}
	}

	func logout(completion: @escaping (Result<MatrixState, Error>) -> Void) {
        debugPrint("MATRIX DEBUG MatrixService logout()")
		// TODO: Пока непонятно в какой момент нужно вызывать этот метод
/*
        client?.logout { response in
            debugPrint("MATRIX DEBUG MatrixService client?.logout response: \(response)")
        }
 */

		session?.logout { response in
            debugPrint("MATRIX DEBUG MatrixService session?.logout response: \(response)")
			switch response {
			case let .failure(error):
				completion(.failure(error))
			case .success:
				self.fileStore.deleteAllData()
				completion(.success(.loggedOut))
			}
		}
	}
}
