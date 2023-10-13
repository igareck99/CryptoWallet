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

        keychainService[.homeServer] = homeServer
        userSettings.userId = userId
        keychainService[.accessToken] = accessToken
        keychainService[.deviceId] = deviceId
        debugPrint("Credetials saved")
    }

    func clearCredentials() {
        debugPrint("Credetials clearCredentials START")
        keychainService.removeObject(forKey: .homeServer)
        userSettings.remoVeObject(forKey: .userId)
        keychainService.removeObject(forKey: .accessToken)
        keychainService.removeObject(forKey: .apiRefreshToken)
        keychainService.removeObject(forKey: .deviceId)
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
