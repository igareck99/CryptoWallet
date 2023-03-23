import AudioToolbox
import Combine
import Foundation

protocol P2PCallUseCaseProtocol: AnyObject {

    var isActiveCallExist: Bool { get }
    
	var delegate: P2PCallUseCaseDelegate? { get set }

	func placeVoiceCall(roomId: String, contacts: [Contact])

	func placeVideoCall(roomId: String, contacts: [Contact])

	func answerCall()

	func endCall()

	func holdCall()

	func changeHoldCall()

	var isMuted: Bool { get }

	func toggleMuteState()

	var isVoiceIsSpeaker: Bool { get }

	var isHoldEnabled: Bool { get }

	func changeVoiceSpeaker()

	var duration: UInt { get }

	var callType: P2PCallType { get }

	var activeCallStateSubject: CurrentValueSubject<P2PCallState, Never> { get }

	var callModelSubject: PassthroughSubject<P2PCall, Never> { get }

	var holdCallEnabledSubject: CurrentValueSubject<Bool, Never> { get }

	var changeHoldedCallEnabledSubject: CurrentValueSubject<Bool, Never> { get }

	var changeHoldedCallEnabledPublisher: AnyPublisher<Bool, Never> { get }
}

protocol P2PCallUseCaseDelegate: AnyObject {
	func callDidChange(state: P2PCallState)
}

final class P2PCallUseCase: NSObject {

	lazy var activeCallStateSubject = CurrentValueSubject<P2PCallState, Never>(activeCallState)
	let callModelSubject = PassthroughSubject<P2PCall, Never>()
	var duration: UInt { activeCall?.duration ?? .zero }

	lazy var holdCallEnabledSubject = CurrentValueSubject<Bool, Never>(isHoldEnabled)

	lazy var changeHoldedCallEnabledSubject = CurrentValueSubject<Bool, Never>(false)
	@Published var isChangeHoldedCallEnabled = false
	var changeHoldedCallEnabledPublisher: AnyPublisher<Bool, Never> {
		$isChangeHoldedCallEnabled.eraseToAnyPublisher()
	}

	private func updateChangeHoldedCall() {
		let isActiveCall = activeCall != nil
		let isOnholdCall = onHoldCall != nil
		let isCallsNotSame = onHoldCall === activeCall
		isChangeHoldedCallEnabled = isActiveCall && isOnholdCall && !isCallsNotSame
	}

	private let router: P2PCallsRouterable
	private let matrixService: MatrixServiceProtocol
	@Published private var activeCall: MXCall?
	@Published private var onHoldCall: MXCall?
	@Published private var calls = [UUID: MXCall]() {
		didSet {
			holdCallEnabledSubject.send(!calls.isEmpty)
			updateChangeHoldedCall()
		}
	}
	private var activeCallState: P2PCallState {
		P2PCallState.state(from: (activeCall?.state ?? .ended))
	}
	private let settings: UserDefaultsServiceProtocol
	private var subscriptions = Set<AnyCancellable>()
	var roomContacts = [Contact]()
	var callType: P2PCallType = .none
	weak var delegate: P2PCallUseCaseDelegate?
	static let shared = P2PCallUseCase()
    var isActiveCallExist: Bool {
        (calls.isEmpty == false) || (activeCall != nil) || (onHoldCall != nil)
    }

	init(
		matrixService: MatrixServiceProtocol = MatrixService.shared,
		router: P2PCallsRouterable = P2PCallsRouter(),
		settings: UserDefaultsServiceProtocol = UserDefaultsService.shared
	) {
		self.matrixService = matrixService
		self.router = router
		self.settings = settings
		super.init()
		observeNotifications()
		configureBindings()
	}

	private func configureBindings() {

		activeCall
			.publisher
			.receive(on: RunLoop.main)
			.sink { [weak self] _ in
				self?.updateChangeHoldedCall()
			}.store(in: &subscriptions)

		onHoldCall
			.publisher
			.receive(on: RunLoop.main)
			.sink { [weak self] _ in
				self?.updateChangeHoldedCall()
			}.store(in: &subscriptions)

		calls
			.publisher
			.receive(on: RunLoop.main)
			.sink { [weak self] _ in
				self?.updateChangeHoldedCall()
			}.store(in: &subscriptions)
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

			let model = P2PCall(
				activeCallerName: callerName(for: call),
				activeCallState: activeCallState,
				onHoldCallerName: "",
				onHoldCallState: .onHold,
				callType: callType,
				isVideoCall: call.isVideoCall,
				interlocutorView: call.remoteVideoView,
				selfyView: call.selfVideoView
			)
			router.showCallView( model: model, p2pCallUseCase: self)
		}
	}

	@objc func callStateDidChage(notification: NSNotification) {

		guard let call = notification.object as? MXCall else {
			debugPrint("Place_Call: callStateChanged NO CALL OBJECT")
			return
		}

		settings.set(true, forKey: .isCallInprogressExists)

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
			// TODO: Подумать как это исправить
			// вью для отображения видеопотока нужно создавать самому
			// иначе звонок не меняет состояние при видео звонке
			configureVideoViewsIfNeeded(call: call)
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
        case .inviteExpired:
            debugPrint("Place_Call: callStateChanged callId: \(call.callId) state: \(call.state)")
        case .answeredElseWhere:
            debugPrint("Place_Call: callStateChanged callId: \(call.callId) state: \(call.state)")
		case .ended:

            guard call.endReason != .answeredElseWhere else { return } // MXCallEndReasonAnsweredElseWhere

			debugPrint("Place_Call: callStateChanged callId: \(call.callId) state: \(call.state)")
			call.hangup()
			updateControllerOnEndOf(endedCall: call)
			settings.set(false, forKey: .isCallInprogressExists)
		default:
			debugPrint("Place_Call: callStateChanged UNKNOWN: \(call.callId) state: \(call.state)")
		}

		activeCallStateSubject.send(activeCallState)
	}

	private func configureVideoViewsIfNeeded(call: MXCall) {

		// Инициализируем видеовью без проверки флага isVideoCall
		// т.к. потенциально нужно будет переключится на видео звонок

		if call.selfVideoView == nil {
			let selfyVideoView = UIView(frame: .init(x: 0, y: 0, width: 40, height: 40))
			call.selfVideoView = selfyVideoView
		}

		if call.remoteVideoView == nil {
			let interlocutorVideoView = UIView(frame: .init(x: 0, y: 0, width: 100, height: 100))
			call.remoteVideoView = interlocutorVideoView
		}
	}

	private func configureAudioSession() {
		// TODO: Создать аудиосервис для переключения аудиопотоков
		try? AVAudioSession.sharedInstance().setActive(false)
		try? AVAudioSession.sharedInstance().setCategory(.playAndRecord)
		try? AVAudioSession.sharedInstance().overrideOutputAudioPort(.none)
		try? AVAudioSession.sharedInstance().setMode(.voiceChat)
		try? AVAudioSession.sharedInstance().setPreferredOutputNumberOfChannels(0)
		try? AVAudioSession.sharedInstance().setActive(true)

		let systemSoundID: SystemSoundID = 1154 // код стандартной мелодии звонка из библиотеки iOS
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

	// Асинхроная загрузка контактов пользователя
	// на случай если контакты еще не успели подгрузится
	// TODO: По-хорошему вынести в MatrixUseCase
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
				callType: self.callType,
				isVideoCall: call.isVideoCall
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
				callType: callType,
				isVideoCall: answeredCall.isVideoCall
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
				callType: callType,
				isVideoCall: call.isVideoCall
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
				callType: callType,
				isVideoCall: holdedCall.isVideoCall
			)
			callModelSubject.send(p2pCall)
			activeCallStateSubject.send(activeCallState)
		}

		guard calls.isEmpty else { return }
		router.removeCallController()
		endAllCalls()
		NotificationCenter.default.post(name: .callDidEnd, object: nil)
	}

	private func notifyIncoming(call: MXCall) {

		guard calls.count <= 1 else { return }

		callType = .incoming
		NotificationCenter.default.post(name: .callDidStart, object: nil)

		let model = P2PCall(
			activeCallerName: callerName(for: call),
			activeCallState: .calling,
			onHoldCallerName: "",
			onHoldCallState: .onHold,
			callType: .incoming,
			isVideoCall: call.isVideoCall,
			interlocutorView: call.remoteVideoView,
			selfyView: call.selfVideoView
		)

		router.showCallView(model: model, p2pCallUseCase: self)
	}

	private func notifyOutcoming(call: MXCall) {
		callType = .outcoming
		NotificationCenter.default.post(name: .callDidStart, object: nil)
		activeCall = call

		let model = P2PCall(
			activeCallerName: callerName(for: call),
			activeCallState: .calling,
			onHoldCallerName: "",
			onHoldCallState: .onHold,
			callType: .outcoming,
			isVideoCall: call.isVideoCall,
			interlocutorView: call.remoteVideoView,
			selfyView: call.selfVideoView
		)

		router.showCallView(model: model, p2pCallUseCase: self)
	}
}

// MARK: - P2PCallUseCaseProtocol

extension P2PCallUseCase: P2PCallUseCaseProtocol {

	func placeVideoCall(roomId: String, contacts: [Contact]) {
		roomContacts = contacts
		matrixService.placeVideoCall(roomId: roomId) { [weak self] result in
			debugPrint("Place_Video_Call: response: \(result)")
			switch result {
			case .success(let call):
				debugPrint("Place_Video_Call: success: call: \(call)")
				self?.calls[call.callUUID] = call
				self?.activeCall = call
			case .failure(let error):
				debugPrint("Place_Video_Call: failure: error: \(error)")
				self?.activeCall = nil
			}
		}
	}

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

	func changeHoldCall() {
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
        
//        call.room.mxSession.callManager.remove

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
