import Foundation

protocol PushKitServiceDelegate: AnyObject {

    func didUpdateVoip(token: Data)

    func didInvalidateVoipToken()
}

protocol PushKitServiceProtocol {
    var delegate: PushKitServiceDelegate? { get set }

    func registerToVoipTokens()

    func unregisterToVoipTokens()

    func requestVoipToken() -> Data?
}
