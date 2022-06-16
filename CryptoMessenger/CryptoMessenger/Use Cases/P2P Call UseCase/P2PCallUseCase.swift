import AudioToolbox
import Combine
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

	var callType: P2PCallType { get }

	var callStateSubject: CurrentValueSubject<P2PCallState, Never> { get }
}

protocol P2PCallUseCaseDelegate: AnyObject {
	func callDidChange(state: P2PCallState)
}

enum P2PCallState: UInt {
	case createOffer
	case ringing
	case calling
	case createAnswer
	case connecting
	case connected
	case inviteExpired
	case ended
	case none
}

enum P2PCallType {
	case outcoming
	case incoming
	case none
}

final class P2PCallUseCase: NSObject {

	lazy var callStateSubject = CurrentValueSubject<P2PCallState, Never>(callState)

	private let router: P2PCallsRouterable
	private let matrixService: MatrixServiceProtocol
	private var activeCall: MXCall?
	private var calls = [UUID: MXCall]()
	private var callState: P2PCallState = .none
	var callType: P2PCallType = .none
	weak var delegate: P2PCallUseCaseDelegate?
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

		NotificationCenter.default.addObserver(
			self,
			selector: #selector(didTapStatusBar(notification:)),
			name: .statusBarTapped,
			object: nil
		)
	}

	@objc func didTapStatusBar(notification: NSNotification) {
		debugPrint("Place_Call: didTapStatusBar notification: \(notification)")

		if !router.isCallViewControllerBeingPresented,
			let call = activeCall {
			let callerName = matrixService.allUsers().first(where: { $0.userId == call.callerId })?.displayname ?? call.callerId
			router.showCallView(
				userName: callerName,
				p2pCallUseCase: self,
				callType: callType,
				callState: callState
			)
		}
	}

	@objc func callStateDidChage(notification: NSNotification) {

		guard let call = notification.object as? MXCall else {
			debugPrint("Place_Call: callStateChanged NO CALL OBJECT")
			return
		}

		debugPrint("Place_Call: callStateChanged state: \(call.state)")

		calls[call.callUUID] = call

		switch call.state {
		case .fledgling:
			debugPrint("Place_Call: callStateChanged fledgling: \(call.callId)")
		case .waitLocalMedia:
			debugPrint("Place_Call: callStateChanged waitLocalMedia: \(call.callId)")
		case .createOffer:
			debugPrint("Place_Call: callStateChanged createOffer: \(call.callId)")
			callState = .createOffer
			notifyOutcoming(call: call)
			callStateSubject.send(.createOffer)
			configureAudioSession()
		case .inviteSent:
			debugPrint("Place_Call: callStateChanged inviteSent: \(call.callId)")
		case .ringing:
			callState = .ringing
			debugPrint("Place_Call: callStateChanged ringing: \(call.callId)")
			callStateSubject.send(.ringing)
		case .createAnswer:
			callState = .createAnswer
			debugPrint("Place_Call: callStateChanged createAnswer: \(call.callId)")
			callStateSubject.send(.createAnswer)
			notifyIncoming(call: call)
		case .connecting:
			callState = .connecting
			debugPrint("Place_Call: callStateChanged connecting: \(call.callId)")
			callStateSubject.send(.connecting)
		case .connected:
			callState = .connected
			debugPrint("Place_Call: callStateChanged connected: \(call.callId)")
			callStateSubject.send(.connected)
		case .ended:
			callState = .ended
			debugPrint("Place_Call: callStateChanged ended: \(call.callId)")
			callStateSubject.send(.ended)
			router.removeCallController()
			NotificationCenter.default.post(name: .callDidEnd, object: nil)
		case .inviteExpired:
			callState = .inviteExpired
			debugPrint("Place_Call: callStateChanged inviteExpired: \(call.callId)")
			call.hangup()
			callStateSubject.send(.inviteExpired)
			router.removeCallController()
			NotificationCenter.default.post(name: .callDidEnd, object: nil)
		case .answeredElseWhere:
			callState = .ended
			debugPrint("Place_Call: callStateChanged answeredElseWhere: \(call.callId)")
			router.removeCallController()
			NotificationCenter.default.post(name: .callDidEnd, object: nil)
		default:
			debugPrint("Place_Call: callStateChanged UNKNOWN: \(call.callId)")
		}
	}

	func configureAudioSession() {
		try? AVAudioSession.sharedInstance().setActive(false)
		try? AVAudioSession.sharedInstance().setCategory(.playAndRecord)
		try? AVAudioSession.sharedInstance().overrideOutputAudioPort(.none)
		try? AVAudioSession.sharedInstance().setMode(.voiceChat)
		try? AVAudioSession.sharedInstance().setPreferredOutputNumberOfChannels(0)
		try? AVAudioSession.sharedInstance().setActive(true)

		let systemSoundID: SystemSoundID = 1154
		AudioServicesPlaySystemSoundWithCompletion(systemSoundID) { [weak self] in
			DispatchQueue.global().asyncAfter(deadline: .now() + 0.6) {
				if self?.activeCall?.state == .createOffer ||
					self?.activeCall?.state == .inviteSent {
					self?.configureAudioSession()
				}
			}
		}
	}

	private func notifyIncoming(call: MXCall) {
		callType = .incoming
		NotificationCenter.default.post(name: .callDidStart, object: nil)
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
		callType = .outcoming
		NotificationCenter.default.post(name: .callDidStart, object: nil)
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
