import Foundation
import MatrixSDK

extension MatrixUseCase {

    func save(credentials: MXCredentials) {
        guard let homeServer = credentials.homeServer,
              let userId = credentials.userId,
              let accessToken = credentials.accessToken,
              let deviceId = credentials.deviceId else {
            return
        }

        userSettings.userId = userId
        keychainService[.homeServer] = homeServer
        keychainService[.accessToken] = accessToken
        keychainService[.deviceId] = deviceId
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
            let homeServer: String = keychainService[.homeServer],
            let userId: String = userSettings.userId,
            let accessToken: String = keychainService[.accessToken],
            let deviceId: String = keychainService[.deviceId]
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
