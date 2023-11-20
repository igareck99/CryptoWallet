import Combine
import Foundation
import UIKit

protocol CallViewModelProtocol: ObservableObject {
    var isVideoCall: Bool { get }
	var userName: String { get }
    var callStateText: String { get }
    var userAvatarImage: UIImage { get }
    var avatarOpacity: Double { get }
    var selfyCallView: UIView? { get }
    var interlocutorCallView: UIView? { get }
	var screenTitle: String { get }
    var callDuration: String { get }
	var sources: CallViewSourcesable.Type { get }
    var actionButtons: [CallActionButton] { get }
    var mediaButtons: [CallActionButton] { get }

	func controllerDidDisappear()
	func controllerDidAppear()
    func didTapAcceptCallButton()
    func didTapEndCallButton()
    func didTapBackButton()
}

final class CallViewModel {
    var isVideoCall: Bool
	let userName: String
    let roomId: String
    var userAvatarImage = UIImage.imageFrom(color: .chineseBlack)
    var avatarOpacity: Double = .zero
	lazy var screenTitle: String = sources.endToEndEncrypted
    var callDuration: String = ""
    var callStateText: String = ""
    var actionButtons = [CallActionButton]()
    var mediaButtons = [CallActionButton]()
    let sources: CallViewSourcesable.Type
    weak var selfyCallView: UIView?
    weak var interlocutorCallView: UIView?

	var callStateTypeSubject = CurrentValueSubject<(P2PCallState, P2PCallType), Never>((.none, .none))
	lazy var callButtonSubject = CurrentValueSubject<Bool, Never>(p2pCallUseCase.callType == .outcoming)

	let endAndAcceptCallButtonSubject = CurrentValueSubject<Bool, Never>(true)
	let holdAndAcceptCallButtonSubject = CurrentValueSubject<Bool, Never>(true)

	let holdCallButtonSubject = CurrentValueSubject<Bool, Never>(false)
	let holdCallButtonActiveSubject = CurrentValueSubject<Bool, Never>(false)

	let changeHoldedCallButtonSubject = CurrentValueSubject<Bool, Never>(false)
	let changeHoldedCallButtonActiveSubject = CurrentValueSubject<Bool, Never>(true)

	lazy var activeCallerNameSubject = CurrentValueSubject<String, Never>(userName)

	private let p2pCallUseCase: P2PCallUseCaseProtocol
    private let matrixUseCase: MatrixUseCaseProtocol
    private var cache: ImageCacheServiceProtocol = ImageCacheService.shared
    private let config: ConfigType

	private var subscribtions: Set<AnyCancellable> = []
	private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    init(
        userName: String,
        roomId: String,
        selfyView: UIView?,
        interlocutorView: UIView?,
        isVideoCall: Bool,
        p2pCallUseCase: P2PCallUseCaseProtocol,
        matrixUseCase: MatrixUseCaseProtocol = MatrixUseCase.shared,
        sources: CallViewSourcesable.Type = CallViewSources.self,
        config: ConfigType = Configuration.shared
    ) {
        self.selfyCallView = selfyView
        self.interlocutorCallView = interlocutorView
        self.userName = userName
        self.roomId = roomId
		self.p2pCallUseCase = p2pCallUseCase
        self.matrixUseCase = matrixUseCase
		self.sources = sources
        self.config = config
        self.isVideoCall = isVideoCall
        configureBindings()
        updateMediaButtonModels()
        updateAvatarOpacity(isVideoCall: isVideoCall)
	}

	deinit {
		timer.upstream.connect().cancel()
        subscribtions.forEach { $0.cancel() }
	}

	private func configureBindings() {
		p2pCallUseCase.activeCallStateSubject
			.subscribe(on: RunLoop.main)
			.sink { [weak self] state in
				self?.update(state: state)
			}
			.store(in: &subscribtions)

		p2pCallUseCase.callModelSubject
			.subscribe(on: RunLoop.main)
			.sink { [weak self] model in
				self?.activeCallerNameSubject.send(model.activeCallerName)
				self?.update(state: model.activeCallState)
			}
			.store(in: &subscribtions)

		p2pCallUseCase.holdCallEnabledSubject
			.subscribe(on: RunLoop.main)
			.sink { [weak self] isHoldEnabled in
				self?.holdCallButtonActiveSubject.send(isHoldEnabled)
			}
			.store(in: &subscribtions)

		p2pCallUseCase.holdCallEnabledSubject
			.subscribe(on: RunLoop.main)
			.sink { [weak self] isHoldButtonEnabled in
				self?.holdCallButtonActiveSubject.send(isHoldButtonEnabled)
			}.store(in: &subscribtions)

		timer
			.receive(on: RunLoop.main)
			.sink { [weak self] _ in
				guard let duration = self?.p2pCallUseCase.duration, duration > .zero else { return }
				let callDuration = duration / 1_000
                // нужно для тестов
//                self?.duration += 1
//                let callDuration = self?.duration ?? 0
				let seconds = callDuration % 60
				let minutes = (callDuration - seconds) / 60
				let durationText = String(format: "%02tu:%02tu", minutes, seconds)
                self?.callDuration = durationText
                self?.objectWillChange.send()
			}.store(in: &subscribtions)

		p2pCallUseCase.changeHoldedCallEnabledPublisher
			.subscribe(on: RunLoop.main)
			.sink { [weak self] isEnabled in
				self?.changeHoldedCallButtonSubject.send(!isEnabled)
				self?.holdCallButtonSubject.send(isEnabled)
			}.store(in: &subscribtions)
	}

    var duration: UInt = 0

	private func update(state: P2PCallState) {
        updateUIDepending(on: state, callType: p2pCallUseCase.callType)
        updateActionButtonModels(callState: state, callType: p2pCallUseCase.callType)
		let isHidden = p2pCallUseCase.callType == .outcoming || state.rawValue > P2PCallState.calling.rawValue
		callButtonSubject.send(isHidden)
	}

    private func getUserAvatar() {
        matrixUseCase.getRoomMembers(roomId: roomId) { result in
            guard case let .success(roomMembers) = result else { return }
            guard let user = roomMembers.members.first(where: { $0.userId.contains(self.userName)
                || $0.displayname.contains(self.userName) }) else { return }
            self.matrixUseCase.getUserAvatar(avatarString: user.avatarUrl) { [weak self] value in
                guard case let .success(image) = value,
                self?.isVideoCall == false else { return }
                self?.userAvatarImage = image
                DispatchQueue.main.async {
                    self?.objectWillChange.send()
                }
            }
        }
    }

    func updateAvatarOpacity(isVideoCall: Bool) {
        avatarOpacity = isVideoCall ? 0 : 1
        self.objectWillChange.send()
    }

    private func updateUIDepending(on callState: P2PCallState, callType: P2PCallType) {

        switch callState {
        case .createOffer, .ringing:
            callStateText = callType == .incoming ? sources.incomingCall : sources.outcomingCall
        case .connecting:
            callStateText = sources.connectionIsEsatblishing
        case .connected:
            callStateText = sources.connectionIsEsatblished
        case .inviteExpired:
            callStateText = sources.userDoesNotRespond
        case .onHold:
            callStateText = sources.youHoldedCall
        case .remotelyOnHold:
            callStateText = sources.otherIsHoldedCall
        case .ended:
            callStateText = sources.callFinished
        default:
            callStateText = ""
        }

        self.objectWillChange.send()
    }

    private func updateActionButtonModels(callState: P2PCallState, callType: P2PCallType) {

        defer { self.objectWillChange.send() }

        if callType == .outcoming ||
            callState.rawValue > P2PCallState.createAnswer.rawValue {
            actionButtons = [
                CallActionButton(
                    backColor: .spanishCrimson,
                    imageName: sources.endCallImgName,
                    imageColor: .white,
                    action: didTapEndCallButton
                )
            ]
            return
        }

        actionButtons = [
            CallActionButton(
                backColor: .greenCrayola,
                imageName: sources.answerCallImgName,
                imageColor: .white,
                action: didTapAcceptCallButton
            ),
            CallActionButton(
                backColor: .spanishCrimson,
                imageName: sources.endCallImgName,
                imageColor: .white,
                action: didTapEndCallButton
            )
        ]
    }

    private func updateMediaButtonModels() {

        mediaButtons = [
            // camera
            CallActionButton(
                text: sources.camera,
                backColor: p2pCallUseCase.isVideoEnabled ?
                    .white : .white.opacity(0.2),
                imageName: p2pCallUseCase.isVideoEnabled ?
                sources.videoEnabledImgName : sources.videoDisabledImgName,
                imageColor: p2pCallUseCase.isVideoEnabled ?
                    .chineseBlack : .white,
                action: didTapVideo
            ),

            // mic
            CallActionButton(
                text: sources.sound,
                backColor: p2pCallUseCase.isMicEnabled ?
                    .white : .white.opacity(0.2),
                imageName: p2pCallUseCase.isMicEnabled ?
                sources.micEnabledImgName : sources.micDisabledImgName,
                imageColor: p2pCallUseCase.isMicEnabled ?
                    .chineseBlack : .white,
                action: didTapMic
            ),

            // speaker
            CallActionButton(
                text: sources.speaker,
                backColor: p2pCallUseCase.isSpeakerEnabled ?
                    .white : .white.opacity(0.2),
                imageName: p2pCallUseCase.isSpeakerEnabled ?
                sources.speakerEnabledImgName : sources.speakerDisabledImgName,
                imageColor: p2pCallUseCase.isSpeakerEnabled ?
                    .chineseBlack : .white,
                action: didTapSpeaker
            )
        ]

        self.objectWillChange.send()
    }
}

// MARK: - CallViewModelProtocol

extension CallViewModel: CallViewModelProtocol {

    func didTapBackButton() {
        p2pCallUseCase.router.removeCallController()
    }

	func controllerDidDisappear() {
		NotificationCenter.default.post(
			name: .callViewDidDisappear,
			object: nil
		)
	}

	func controllerDidAppear() {
		NotificationCenter.default.post(
			name: .callViewDidAppear,
			object: nil
		)

        getUserAvatar()
        p2pCallUseCase.changeVoiceSpeaker()
	}
}

// MARK: - VideoAudioItemsDelegate

extension CallViewModel {

	func didTapVideo() {
        p2pCallUseCase.toggleVideoState()
        updateMediaButtonModels()
	}

	func didTapMic() {
		p2pCallUseCase.toggleMuteState()
        updateMediaButtonModels()
	}

	func didTapSpeaker() {
		p2pCallUseCase.changeVoiceSpeaker()
        updateMediaButtonModels()
	}

	func didTapAcceptCallButton() {
		p2pCallUseCase.answerCall()
	}

	func didTapEndCallButton() {
		p2pCallUseCase.endCall()
	}

    // функционал переключения звонков пока отключен
	func didTapHoldCallButton() {
		p2pCallUseCase.holdCall()
	}

	func didTapChangeHoldedCallButton() {
		p2pCallUseCase.changeHoldCall()
	}
}
