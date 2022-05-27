import Foundation
import MatrixSDK

protocol P2PCallUseCaseProtocol {
	func placeVoiceCall(roomId: String)
}

protocol P2PCallUseCaseDelegate: AnyObject {
	func callDidChange(state: P2PCallUseCase.CallState)
}

final class P2PCallUseCase: NSObject {

	enum CallState {
		case calling
		case connecting
		case connected
		case inviteExpired
		case ended
	}

	enum CallType {
		case outcoming
		case incoming
	}

	private let router: P2PCallsRouterable
	private let matrixService: MatrixServiceProtocol
	private let callKitService: CallKitServiceProtocol
	private var activeCall: MXCall?
	private var calls = [UUID: MXCall]()
	weak var delegate: P2PCallUseCaseDelegate?

	static let shared = P2PCallUseCase()

	init(
		matrixService: MatrixServiceProtocol = MatrixService.shared,
		callKitService: CallKitServiceProtocol = CallKitService.shared,
		router: P2PCallsRouterable = P2PCallsRouter()
	) {
		self.matrixService = matrixService
		self.callKitService = callKitService
		self.router = router
		super.init()
		configure()
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

	private func configure() {
		callKitService.update(delegate: self)
	}

	@objc func callStateDidChage(notification: NSNotification) {

		guard let call = notification.object as? MXCall else {
			debugPrint("Place_Call: callStateChanged NO CALL OBJECT")
			return
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
		case .inviteSent:
			debugPrint("Place_Call: callStateChanged inviteSent: \(call.callId)")
		case .ringing:
			debugPrint("Place_Call: callStateChanged ringing: \(call.callId)")
		case .createAnswer:
			debugPrint("Place_Call: callStateChanged createAnswer: \(call.callId)")
			notifyIncoming(call: call)
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

	private func notifyIncoming(call: MXCall) {
		activeCall = call
		let callerName = matrixService.allUsers().first(where: { $0.userId == call.callerId })?.displayname ?? call.callerId
		router.showCallView(
			userName: callerName,
			p2pCallUseCase: self,
			callType: .incoming,
			callState: .connecting,
			delegate: self
		)
	}

	private func notifyOutcoming(call: MXCall) {
		activeCall = call
		let callerName = matrixService.allUsers().first(where: { $0.userId == call.callerId })?.displayname ?? call.callerId
		router.showCallView(
			userName: callerName,
			p2pCallUseCase: self,
			callType: .outcoming,
			callState: .calling,
			delegate: self
		)
	}
}

// MARK: - CallKit

private extension P2PCallUseCase {

	func callKit_notifyIncoming(call: MXCall) {
		let handleValue = getHandleValue(call: call)
		debugPrint("Place_Call: makeCallKitNotification handleValue: \(handleValue)")
		let callerName = matrixService.allUsers().first(where: { $0.userId == call.callerId })?.displayname ?? ""
		callKitService.notifyIncomingCall(
			callUUID: call.callUUID,
			value: handleValue,
			userName: callerName,
			isVideoCall: false
		) { [weak self] result in
			debugPrint("Place_Call: notifyIncomingCall result: \(result)")
			if result == false {
				call.hangup()
				self?.calls[call.callUUID] = nil
				self?.activeCall = nil
			}
		}
	}

	func callKit_notifyOutcoming(call: MXCall) {
		let handleValue = getHandleValue(call: call)
		callKitService.notifyInitiatedCall(
			callUUID: call.callUUID,
			value: handleValue,
			userId: call.callerId,
			isVideoCall: false
		) {[weak self] result in
			debugPrint("Place_Call: notifyOutcoming result: \(result)")
			if result == false {
				call.hangup()
				self?.calls[call.callUUID] = nil
				self?.activeCall = nil
			}
		}
	}

	func notifyEndOf(call: MXCall) { }

	func getHandleValue(call: MXCall) -> String {
		let handleValue: String
		if let roomId = call.room.roomId {
			handleValue = roomId
		} else {
			handleValue = call.callerId
		}
		return handleValue
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

// MARK: - CallKitServiceDelegate

extension P2PCallUseCase: CallKitServiceDelegate {

	func userDidStartCall(with callUUID: UUID, completion: @escaping (Bool) -> Void) {
		guard let call = calls[callUUID] else { completion(false); return }
		debugPrint("Place_Call: CallKitServiceDelegate userDidStartCall call: \(call)")
		// TODO: Обработать начало звонка
		completion(true)
	}

	func userDidAnswerCall(with callUUID: UUID, completion: @escaping (Bool) -> Void) {
		guard let call = calls[callUUID] else { completion(false); return }
		debugPrint("Place_Call: CallKitServiceDelegate userDidAnswerCall call: \(call)")
		// TODO: Обработать начало разговора
		completion(true)
		// TODO: Выполнить дополнительные настройки аудиосессии для страта звонка
//		[self.audioSessionConfigurator configureAudioSessionForVideoCall:call.isVideoCall];
	}

	func userDidEndCall(with callUUID: UUID) {
		guard let call = calls[callUUID] else { return }
		debugPrint("Place_Call: CallKitServiceDelegate userDidEndCall call: \(call)")
		call.hangup()
		calls[callUUID] = nil
		// TODO: Выполнить дополнительные настройки аудиосессии для окончания звонка
//		[self.audioSessionConfigurator configureAudioSessionAfterCallEnds];
	}

	func userDidChangeCallMuteState(with callUUID: UUID, isMuted: Bool) {
		guard let call = calls[callUUID] else { return }
		debugPrint("Place_Call: CallKitServiceDelegate userDidChangeCallMuteState isMuted: \(isMuted)")
		call.audioMuted = isMuted
	}

	func userDidChangeCallHoldState(with callUUID: UUID, isOnHold: Bool) {
		guard let call = calls[callUUID] else { return }
		debugPrint("Place_Call: CallKitServiceDelegate userDidChangeCallHoldState isOnHold: \(isOnHold) call: \(call)")
		// TODO: Нет проперти и метода чтобы отправлять звонок на удержание, нужно обновить MatrixSDK
//		[call hold:action.onHold];
//		call.isOnHold = isOnHold
	}
}

// MARK: - CallViewControllerDelegate

extension P2PCallUseCase: CallViewControllerDelegate {

	func acceptCallButtonDidTap() {
		self.activeCall?.answer()
	}

	func endCallButtonDidTap() {
		activeCall?.hangup()
		activeCall = nil
		calls = [:]
	}

	func controllerDidDisappear() {
		activeCall?.hangup()
		activeCall = nil
		calls = [:]
	}
}
