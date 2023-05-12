import Foundation

class PushKitServiceMock: PushKitServiceProtocol {
    var delegate: PushKitServiceDelegate?

    func registerToVoipTokens() {}

    func unregisterToVoipTokens() {}

    func requestVoipToken() -> Data? { nil }
}
