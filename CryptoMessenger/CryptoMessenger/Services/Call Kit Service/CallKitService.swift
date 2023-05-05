import CallKit
import Foundation
import UIKit
import PushKit

final class CallKitService: NSObject, CXProviderDelegate, PKPushRegistryDelegate {

    static let shared = CallKitService()

    override init() {
        super.init()
        let registry = PKPushRegistry(queue: nil)
        registry.delegate = self
        registry.desiredPushTypes = [PKPushType.voIP]
    }

    func providerDidReset(_ provider: CXProvider) {
    }

    func provider(_ provider: CXProvider, perform action: CXAnswerCallAction) {
        action.fulfill()
    }

    func provider(_ provider: CXProvider, perform action: CXEndCallAction) {
        action.fulfill()
    }

    func pushRegistry(_ registry: PKPushRegistry, didUpdate pushCredentials: PKPushCredentials, for type: PKPushType) {
        let token = pushCredentials.token.map { String(format: "%02.2hhx", $0) }.joined()
        debugPrint("CallKitService pushCredentials: \(token)")
    }

    func pushRegistry(
        _ registry: PKPushRegistry,
        didReceiveIncomingPushWith payload: PKPushPayload,
        for type: PKPushType,
        completion: @escaping () -> Void
    ) {
        
        debugPrint("CallKitService PKPushPayload: \(payload.dictionaryPayload)")
        
        let config = CXProviderConfiguration()
        config.iconTemplateImageData = UIImage(named: "AppIcon")!.pngData()
        config.ringtoneSound = "ringtone.caf"
        config.includesCallsInRecents = false
        config.supportsVideo = true
        let provider = CXProvider(configuration: config)
        provider.setDelegate(self, queue: nil)
        let update = CXCallUpdate()
        update.remoteHandle = CXHandle(type: .generic, value: "Pete Za")
        update.hasVideo = true
        provider.reportNewIncomingCall(with: UUID(), update: update) { error in
            debugPrint(error?.localizedDescription)
        }
    }

}
