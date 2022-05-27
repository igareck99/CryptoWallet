import AVFoundation
import CallKit
import Foundation
import UIKit

protocol CallKitServiceProtocol {

	func update(delegate: CallKitServiceDelegate)

	func notifyIncomingCall(
		callUUID: UUID,
		value: String,
		userName: String,
		isVideoCall: Bool,
		completion: @escaping (Bool) -> Void
	)

	func notifyInitiatedCall(
		callUUID: UUID,
		value: String,
		userId: String,
		isVideoCall: Bool,
		completion: @escaping (Bool) -> Void
	)
}

protocol CallKitServiceDelegate: AnyObject {
	func userDidStartCall(with callUUID: UUID, completion: @escaping (Bool) -> Void)
	func userDidAnswerCall(with callUUID: UUID, completion: @escaping (Bool) -> Void)
	func userDidEndCall(with callUUID: UUID)
	func userDidChangeCallMuteState(with callUUID: UUID, isMuted: Bool)
	func userDidChangeCallHoldState(with callUUID: UUID, isOnHold: Bool)
}

final class CallKitService: NSObject {

	private var provider: CXProvider?
	private let callController: CXCallController
	weak var delegate: CallKitServiceDelegate?

	static let shared = CallKitService()

	override init() {
		let config = Self.makeProviderConfiguration()
		provider = CXProvider(configuration: config)
		callController = CXCallController(queue: .main)
		super.init()
		provider?.setDelegate(self, queue: .main)
	}

	private static func makeProviderConfiguration() -> CXProviderConfiguration {
		let config = CXProviderConfiguration()
		config.maximumCallGroups = 1
		config.maximumCallsPerCallGroup = 1
		config.supportedHandleTypes = [.generic]
		config.supportsVideo = false
		config.iconTemplateImageData = UIImage(named: "AppIcon")?.pngData()
		return config
	}

	deinit {
		provider?.setDelegate(nil, queue: nil)
		provider?.invalidate()
		provider = nil
	}
}

// MARK: - CallKitServiceProtocol

extension CallKitService: CallKitServiceProtocol {

	func update(delegate: CallKitServiceDelegate) {
		self.delegate = delegate
	}

	func notifyIncomingCall(
		callUUID: UUID,
		value: String,
		userName: String,
		isVideoCall: Bool,
		completion: @escaping (Bool) -> Void
	) {

		let handle = CXHandle(type: .generic, value: value)
		let update = CXCallUpdate()
		update.remoteHandle = handle
		update.localizedCallerName = userName
		update.hasVideo = isVideoCall
		update.supportsHolding = false
		update.supportsGrouping = false
		update.supportsUngrouping = false
		update.supportsDTMF = false

		provider?.reportNewIncomingCall(
			with: callUUID,
			update: update) { error in
				debugPrint("Place_Call: reportNewIncomingCall result: \(String(describing: error))")
				completion(error == nil)
			}
	}

	func notifyInitiatedCall(
		callUUID: UUID,
		value: String,
		userId: String,
		isVideoCall: Bool,
		completion: @escaping (Bool) -> Void
	) {

		let handle = CXHandle(type: .generic, value: value)
		let action = CXStartCallAction(call: callUUID, handle: handle)
		action.contactIdentifier = userId

		let transaction = CXTransaction(action: action)

		callController.request(transaction) { [weak self] error in

			let update = CXCallUpdate()
			update.remoteHandle = handle
			update.localizedCallerName = userId
			update.hasVideo = isVideoCall
			update.supportsHolding = false
			update.supportsGrouping = false
			update.supportsUngrouping = false
			update.supportsDTMF = false
			self?.provider?.reportCall(with: callUUID, updated: update)
			completion(error == nil)
		}
	}

	func notifyEndedCall() {}
}

// MARK: - CXProviderDelegate

extension CallKitService: CXProviderDelegate {

	func providerDidReset(_ provider: CXProvider) {
		debugPrint("Place_Call: CXProviderDelegate providerDidReset")
	}

	func providerDidBegin(_ provider: CXProvider) {
		debugPrint("Place_Call: CXProviderDelegate providerDidBegin")
	}

	func provider(_ provider: CXProvider, perform action: CXStartCallAction) {
		let callUUID = action.callUUID
		debugPrint("Place_Call: CXProviderDelegate perform CXStartCallAction callUUID: \(callUUID)")
		delegate?.userDidStartCall(with: callUUID) { result in
			if result {
				action.fulfill()
			} else {
				action.fail()
			}
		}
	}

	func provider(_ provider: CXProvider, perform action: CXAnswerCallAction) {
		let callUUID = action.callUUID
		debugPrint("Place_Call: CXProviderDelegate perform CXAnswerCallAction callUUID: \(callUUID)")
		delegate?.userDidAnswerCall(with: callUUID) { result in
			if result {
				action.fulfill()
			} else {
				action.fail()
			}
		}
	}

	func provider(_ provider: CXProvider, perform action: CXEndCallAction) {
		let callUUID = action.callUUID
		debugPrint("Place_Call: CXProviderDelegate perform CXEndCallAction callUUID: \(callUUID)")
		delegate?.userDidEndCall(with: callUUID)
		action.fulfill()
	}

	func provider(_ provider: CXProvider, perform action: CXSetHeldCallAction) {
		let callUUID = action.callUUID
		debugPrint("Place_Call: CXProviderDelegate perform CXSetHeldCallAction callUUID: \(callUUID)")
		delegate?.userDidChangeCallHoldState(with: callUUID, isOnHold: action.isOnHold)
		action.fulfill()
	}

	func provider(_ provider: CXProvider, perform action: CXSetMutedCallAction) {
		let callUUID = action.callUUID
		debugPrint("Place_Call: CXProviderDelegate perform CXSetMutedCallAction callUUID: \(callUUID)")
		delegate?.userDidChangeCallMuteState(with: callUUID, isMuted: action.isMuted)
		action.fulfill()
	}

	func provider(_ provider: CXProvider, perform action: CXSetGroupCallAction) {
		debugPrint("Place_Call: CXProviderDelegate perform CXSetGroupCallAction")
		action.fulfill()
	}

	func provider(_ provider: CXProvider, perform action: CXPlayDTMFCallAction) {
		debugPrint("Place_Call: CXProviderDelegate perform CXPlayDTMFCallAction")
		action.fulfill()
	}

	func provider(_ provider: CXProvider, timedOutPerforming action: CXAction) {
		debugPrint("Place_Call: CXProviderDelegate timedOutPerforming CXAction")
		action.fulfill()
	}

	func provider(_ provider: CXProvider, didActivate audioSession: AVAudioSession) {
		debugPrint("Place_Call: CXProviderDelegate didActivate audioSession")
	}

	func provider(_ provider: CXProvider, didDeactivate audioSession: AVAudioSession) {
		debugPrint("Place_Call: CXProviderDelegate didDeactivate audioSession")
	}
}
