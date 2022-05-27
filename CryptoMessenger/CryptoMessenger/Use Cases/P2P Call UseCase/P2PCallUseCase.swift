import Foundation
import MatrixSDK

protocol P2PCallUseCaseProtocol: AnyObject {

	var delegate: P2PCallUseCaseDelegate? { get set }

	func placeVoiceCall(roomId: String)

	func answerCall()

	func endCall()


	var isMuted: Bool { get }

	func toggleMuteState()

	var isVoiceIsSpeaker: Bool { get }

	func changeVoiceSpeaker()
}

protocol P2PCallUseCaseDelegate: AnyObject {
	func callDidChange(state: P2PCallState)
}

enum P2PCallState: UInt {
	case createOffer
	case ringing
	case calling
	case connecting
	case connected
	case inviteExpired
	case ended
}

enum P2PCallType {
	case outcoming
	case incoming
}

final class P2PCallUseCase: NSObject {

	private let router: P2PCallsRouterable
	private let matrixService: MatrixServiceProtocol
	private var activeCall: MXCall?
	private var calls = [UUID: MXCall]()
	weak var delegate: P2PCallUseCaseDelegate?
	private var callState: MXCallState = .fledgling

	static let shared = P2PCallUseCase()

	init(
		matrixService: MatrixServiceProtocol = MatrixService.shared,
		router: P2PCallsRouterable = P2PCallsRouter()
	) {
		self.matrixService = matrixService
		self.router = router
		super.init()
		observeNotifications()
	}

	private func observeNotifications() {
		NotificationCenter.default.addObserver(
			self,
			selector: #selector(callStateDidChage(notification:)),
			name: .callStateDidChange,
			object: nil
		)
	}

	@objc func callStateDidChage(notification: NSNotification) {

		guard let call = notification.object as? MXCall else {
			debugPrint("Place_Call: callStateChanged NO CALL OBJECT")
			return
		}

		debugPrint("Place_Call: callStateChanged state: \(call.state)")

		calls[call.callUUID] = call

		callState = call.state

		switch call.state {
		case .fledgling:
			debugPrint("Place_Call: callStateChanged fledgling: \(call.callId)")
		case .waitLocalMedia:
			debugPrint("Place_Call: callStateChanged waitLocalMedia: \(call.callId)")
		case .createOffer:
			debugPrint("Place_Call: callStateChanged createOffer: \(call.callId)")
			notifyOutcoming(call: call)
			delegate?.callDidChange(state: .createOffer)
		case .inviteSent:
			debugPrint("Place_Call: callStateChanged inviteSent: \(call.callId)")
		case .ringing:
			debugPrint("Place_Call: callStateChanged ringing: \(call.callId)")
			notifyIncoming(call: call)
			delegate?.callDidChange(state: .ringing)
			playRingSound()
		case .createAnswer:
			debugPrint("Place_Call: callStateChanged createAnswer: \(call.callId)")
		case .connecting:
			debugPrint("Place_Call: callStateChanged connecting: \(call.callId)")
			delegate?.callDidChange(state: .connecting)
		case .connected:
			debugPrint("Place_Call: callStateChanged connected: \(call.callId)")
			delegate?.callDidChange(state: .connected)
		case .ended:
			debugPrint("Place_Call: callStateChanged ended: \(call.callId)")
			delegate?.callDidChange(state: .ended)
			router.removeCallController()
		case .inviteExpired:
			debugPrint("Place_Call: callStateChanged inviteExpired: \(call.callId)")
			delegate?.callDidChange(state: .inviteExpired)
			router.removeCallController()
		case .answeredElseWhere:
			debugPrint("Place_Call: callStateChanged answeredElseWhere: \(call.callId)")
			router.removeCallController()
		default:
			debugPrint("Place_Call: callStateChanged UNKNOWN: \(call.callId)")
		}
	}

	private func playRingSound() {
		AudioServicesPlaySystemSoundWithCompletion(kSystemSoundID_Vibrate) { [weak self] in
			if Thread.isMainThread {
				debugPrint("Place_Call: MAIN THREAD")
			} else {
				debugPrint("Place_Call: NOT MAIN THREAD")
			}

			DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
				if self?.callState == .ringing {
					self?.playRingSound()
				}
			}
		}
	}

	private func notifyIncoming(call: MXCall) {
		activeCall = call
		activeCall?.delegate = self
		let callerName = matrixService.allUsers().first(where: { $0.userId == call.callerId })?.displayname ?? call.callerId
		router.showCallView(
			userName: callerName,
			p2pCallUseCase: self,
			callType: .incoming,
			callState: .calling
		)
	}

	private func notifyOutcoming(call: MXCall) {
		activeCall = call
		let callerName = matrixService.allUsers().first(where: { $0.userId == call.callerId })?.displayname ?? call.callerId
		router.showCallView(
			userName: callerName,
			p2pCallUseCase: self,
			callType: .outcoming,
			callState: .calling
		)
	}
}

// MARK: - P2PCallUseCaseProtocol

extension P2PCallUseCase: P2PCallUseCaseProtocol {

	func placeVoiceCall(roomId: String) {
		matrixService.placeVoiceCall(roomId: roomId) { [weak self] result in
			debugPrint("Place_Call: response: \(result)")
			switch result {
			case .success(let call):
				debugPrint("Place_Call: success: call: \(call)")
				self?.calls[call.callUUID] = call
				self?.activeCall = call
			case .failure(let error):
				debugPrint("Place_Call: failure: error: \(error)")
				self?.activeCall = nil
			}
		}
	}

	func answerCall() {
		self.activeCall?.answer()
	}

	func endCall() {
		guard let call = activeCall else { return }
		calls[call.callUUID] = nil
		activeCall?.hangup()
		activeCall = nil
	}

	func endAllCalls() {

		activeCall?.hangup()
		activeCall = nil

		for (_, value) in calls {
			value.hangup()
			calls[value.callUUID] = nil
		}
		calls = [:]
	}

	var isMuted: Bool { activeCall?.audioMuted == true }

	func toggleMuteState() {
		activeCall?.audioMuted = activeCall?.audioMuted == true ? false : true
	}

	var isVoiceIsSpeaker: Bool { activeCall?.audioToSpeaker == true }

	func changeVoiceSpeaker() {
		activeCall?.audioToSpeaker = activeCall?.audioToSpeaker == true ? false : true
	}
}

// MARK: - MXCallDelegate

extension P2PCallUseCase: MXCallDelegate {

	func call(_ call: MXCall, stateDidChange state: MXCallState, reason event: MXEvent?) {
		debugPrint("Place_Call: MXCallDelegate stateDidChange state: \(state)")
	}

	func call(_ call: MXCall, didEncounterError error: Error) {
		debugPrint("Place_Call: MXCallDelegate didEncounterError error: \(error)")
	}
}
