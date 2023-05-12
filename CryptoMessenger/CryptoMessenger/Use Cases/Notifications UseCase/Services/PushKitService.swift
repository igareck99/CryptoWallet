import CallKit
import Foundation
import PushKit

final class PushKitService: NSObject, PushKitServiceProtocol {

    weak var delegate: PushKitServiceDelegate?
    weak var registry: PKPushRegistry?

    deinit {
        debugPrint("NotificationsUseCase PushKitService deinit")
    }

    func registerToVoipTokens() {
        let registry = PKPushRegistry(queue: nil)
        registry.delegate = self
        registry.desiredPushTypes = [.voIP]
        self.registry = registry
    }

    func unregisterToVoipTokens() {
        guard self.registry?.delegate === self else { return }
        self.registry?.delegate = nil
    }

    func requestVoipToken() -> Data? {
        registry?.pushToken(for: .voIP)
    }
}

// MARK: - PKPushRegistryDelegate

extension PushKitService: PKPushRegistryDelegate {
    func pushRegistry(
        _ registry: PKPushRegistry,
        didUpdate pushCredentials: PKPushCredentials,
        for type: PKPushType
    ) {
        defer { unregisterToVoipTokens() }
        self.registry = registry
        guard type == .voIP else { return }
        delegate?.didUpdateVoip(token: pushCredentials.token)
    }

    func pushRegistry(
        _ registry: PKPushRegistry,
        didInvalidatePushTokenFor type: PKPushType
    ) {
        guard type == .voIP else { return }
        delegate?.didInvalidateVoipToken()
    }
}
