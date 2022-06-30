import AudioToolbox
import Combine
import Foundation
import MatrixSDK

protocol P2PCallUseCaseProtocol: AnyObject {

	var delegate: P2PCallUseCaseDelegate? { get set }

	func placeVoiceCall(roomId: String, contacts: [Contact])

	func answerCall()

	func endCall()

	func holdCall()

	var isMuted: Bool { get }

	func toggleMuteState()

	var isVoiceIsSpeaker: Bool { get }

	var isHoldEnabled: Bool { get }

	func changeVoiceSpeaker()

	var callType: P2PCallType { get }

	var activeCallStateSubject: CurrentValueSubject<P2PCallState, Never> { get }

	var callModelSubject: PassthroughSubject<P2PCall, Never> { get }

	var holdCallEnabledSubject: CurrentValueSubject<Bool, Never> { get }
}

protocol P2PCallUseCaseDelegate: AnyObject {
	func callDidChange(state: P2PCallState)
}

final class P2PCallUseCase: NSObject {

	lazy var activeCallStateSubject = CurrentValueSubject<P2PCallState, Never>(activeCallState)
	let callModelSubject = PassthroughSubject<P2PCall, Never>()

	lazy var holdCallEnabledSubject = CurrentValueSubject<Bool, Never>(true)

	private let router: P2PCallsRouterable
	private let matrixService: MatrixServiceProtocol
	private var activeCall: MXCall?
	private var onHoldCall: MXCall?
	private var calls = [UUID: MXCall]() {
		didSet {
			holdCallEnabledSubject.send(!calls.isEmpty)
		}
	}
	private var activeCallState: P2PCallState {
		P2PCallState.state(from: (activeCall?.state ?? .ended))
	}
	var roomContacts = [Contact]()
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
			let callerName = callerName(for: call)
			router.showCallView(
				userName: callerName,
				p2pCallUseCase: self,
				callType: callType,
				callState: activeCallState
			)
		}
	}

	@objc func callStateDidChage(notification: NSNotification) {

		guard let call = notification.object as? MXCall else {
			debugPrint("Place_Call: callStateChanged NO CALL OBJECT")
			return
		}

		debugPrint("Place_Call: callStateChanged state: \(call.state)")

		if activeCall != nil,
		   activeCall?.callUUID != call.callUUID,
		   calls[call.callUUID] != call {
			debugPrint("Place_Call: callStateChanged ANOTHER_INCOMING_CALL: \(call.callUUID) state: \(call.state)")
		}

		if calls.isEmpty,
			activeCall == nil {
			activeCall = call
		}

		calls[call.callUUID] = call

		switch call.state {
		case .fledgling:
			debugPrint("Place_Call: callStateChanged fledgling: \(call.callId)")
		case .waitLocalMedia:
			debugPrint("Place_Call: callStateChanged waitLocalMedia: \(call.callId)")
		case .createOffer:
			debugPrint("Place_Call: callStateChanged createOffer: \(call.callId)")
			notifyOutcoming(call: call)
			configureAudioSession()
		case .inviteSent:
			debugPrint("Place_Call: callStateChanged inviteSent: \(call.callId)")
		case .ringing:
			debugPrint("Place_Call: callStateChanged ringing: \(call.callId)")
		case .createAnswer:
			debugPrint("Place_Call: callStateChanged createAnswer: \(call.callId)")
			notifyIncoming(call: call)
		case .connecting:
			debugPrint("Place_Call: callStateChanged connecting: \(call.callId)")
		case .connected:
			activeCall = call
			updateControllerOnAnswerOf(answeredCall: call)
			debugPrint("Place_Call: callStateChanged connected: \(call.callId)")
		case .onHold:
			updateControllerOnHoldOf(holdedCall: call)
			debugPrint("Place_Call: callStateChanged connected: \(call.callId)")
		case .ended, .inviteExpired, .answeredElseWhere:
			debugPrint("Place_Call: callStateChanged callId: \(call.callId) state: \(call.state)")
			call.hangup()
			updateControllerOnEndOf(endedCall: call)
		default:
			debugPrint("Place_Call: callStateChanged UNKNOWN: \(call.callId) state: \(call.state)")
		}

		activeCallStateSubject.send(activeCallState)
	}

	private func configureAudioSession() {
		try? AVAudioSession.sharedInstance().setActive(false)
		try? AVAudioSession.sharedInstance().setCategory(.playAndRecord)
		try? AVAudioSession.sharedInstance().overrideOutputAudioPort(.none)
		try? AVAudioSession.sharedInstance().setMode(.voiceChat)
		try? AVAudioSession.sharedInstance().setPreferredOutputNumberOfChannels(0)
		try? AVAudioSession.sharedInstance().setActive(true)

		let systemSoundID: SystemSoundID = 1154
		AudioServicesPlaySystemSoundWithCompletion(systemSoundID) { [weak self] in
			DispatchQueue.global().asyncAfter(deadline: .now() + 0.5) {
				if self?.activeCall?.state == .createOffer ||
					self?.activeCall?.state == .inviteSent {
					self?.configureAudioSession()
				}
			}
		}
	}

	private func callerName(for call: MXCall) -> String {

		if call.isIncoming == false,
			let callerName = roomContacts.first(where: { call.callerId.contains($0.name) == false })?.name {
			return callerName
		}

		return call.callerName ?? call.room.roomId
	}

	private func asyncCallerName(for call: MXCall) {
		call.room.members { [weak self] response in

			guard let self = self,
				  case .success(let members) = response,
				  let roomMembers = members?.members else { return }

			let callerName = roomMembers.first {
				call.callerId.contains($0.userId) == false
			}?.userId ?? call.callerName ?? call.room.roomId ?? ""

			var holdedCallerName = ""
			if let callOnHold = self.onHoldCall {
				holdedCallerName = self.callerName(for: callOnHold)
			}

			let p2pCall = P2PCall(
				activeCallerName: callerName,
				activeCallState: self.activeCallState,
				onHoldCallerName: holdedCallerName,
				onHoldCallState: .onHold,
				callType: self.callType
			)
			self.callModelSubject.send(p2pCall)
			self.activeCallStateSubject.send(self.activeCallState)
		}
	}

	private func updateControllerOnAnswerOf(answeredCall: MXCall) {
		activeCall = answeredCall

		if let call = calls.first(where: { $0.0 != answeredCall.callUUID })?.value {

			onHoldCall = call
			call.hold(true)

			let holdedCallerName = callerName(for: call)
			let callerName = callerName(for: answeredCall)
			let p2pCall = P2PCall(
				activeCallerName: callerName,
				activeCallState: activeCallState,
				onHoldCallerName: holdedCallerName,
				onHoldCallState: .onHold,
				callType: callType
			)
			callModelSubject.send(p2pCall)
			activeCallStateSubject.send(activeCallState)
		}
	}

	private func updateControllerOnHoldOf(holdedCall: MXCall) {
		onHoldCall = holdedCall

		if let call = calls.first(where: { $0.0 != holdedCall.callUUID })?.value {

			call.hold(false)
			activeCall = call
			let holdedCallerName = callerName(for: holdedCall)
			let callerName = callerName(for: call)
			let p2pCall = P2PCall(
				activeCallerName: callerName,
				activeCallState: activeCallState,
				onHoldCallerName: holdedCallerName,
				onHoldCallState: .onHold,
				callType: callType
			)
			callModelSubject.send(p2pCall)
			activeCallStateSubject.send(activeCallState)
		}
	}

	private func updateControllerOnEndOf(endedCall: MXCall) {

		debugPrint("Place_Call: updateControllerOnEndOf endedCall: \(endedCall.callId)")

		calls[endedCall.callUUID] = nil

		if let holdedCall = calls.first?.value {
			debugPrint("Place_Call: updateControllerOnEndOf retrive holded call: \(holdedCall.callId)")
			holdedCall.hold(false)
			activeCall = holdedCall
			let callerName = callerName(for: holdedCall)
			let p2pCall = P2PCall(
				activeCallerName: callerName,
				activeCallState: activeCallState,
				onHoldCallerName: "",
				onHoldCallState: .none,
				callType: callType
			)
			callModelSubject.send(p2pCall)
			activeCallStateSubject.send(activeCallState)
		}

		guard calls.isEmpty else { return }
		router.removeCallController()
		NotificationCenter.default.post(name: .callDidEnd, object: nil)
	}

	private func notifyIncoming(call: MXCall) {

		guard calls.count <= 1 else { return }

		callType = .incoming
		NotificationCenter.default.post(name: .callDidStart, object: nil)
		let callerName = callerName(for: call)
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
		let callerName = callerName(for: call)
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

	func placeVoiceCall(roomId: String, contacts: [Contact]) {
		roomContacts = contacts
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

	var isHoldEnabled: Bool { calls.count > 1 }

	func holdCall() {
		activeCall?.hold(!(activeCall?.isOnHold == true))
	}

	func answerCall() {
		activeCall?.answer()
	}

	func endCall() {
		guard let call = activeCall else { return }
		calls[call.callUUID] = nil
		activeCall?.hangup()
		activeCall = nil

		guard onHoldCall == nil else { return }
		endAllCalls()
	}

	func endAllCalls() {

		activeCall?.hangup()
		activeCall = nil
		onHoldCall?.hangup()
		onHoldCall = nil

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

	var isVoiceIsSpeaker: Bool {
		activeCall?.audioOutputRouter.currentRoute?.routeType == .loudSpeakers
	}

	func changeVoiceSpeaker() {
		let audioRoute: MXiOSAudioOutputRoute? = isVoiceIsSpeaker ?
		activeCall?.audioOutputRouter.builtInRoute :
		activeCall?.audioOutputRouter.loudSpeakersRoute
		activeCall?.audioOutputRouter.changeCurrentRoute(to: audioRoute)
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
