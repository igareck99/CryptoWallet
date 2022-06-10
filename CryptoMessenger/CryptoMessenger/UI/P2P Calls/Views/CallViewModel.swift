import Combine
import Foundation
import UIKit

protocol VideoAudioItemsDelegate {
	func didTapVideo(button: ViewUpdatable)
	func didTapMic(button: ViewUpdatable)
	func didTapSpeaker(button: ViewUpdatable)
	func didTapAcceptCallButton()
	func didTapEndCallButton()
}

protocol CallViewModelProtocol {
	var userName: String { get }
	var screenTitle: String { get }
	var sources: CallViewSourcesable.Type { get }
	var videoAudioStackModel: HStackViewModel? { get }
	var answerEndCallStackModel: HStackViewModel? { get }
	var callStateTypeSubject: CurrentValueSubject<(P2PCallState, P2PCallType), Never> { get }

	func controllerWillAppear()
	func controllerDidDisappear()
	func controllerDidAppear()
}

final class CallViewModel {

	let userName: String
	let screenTitle: String = "Защищено сквозным шифрованием"
	var videoAudioStackModel: HStackViewModel?
	var answerEndCallStackModel: HStackViewModel?

	var callStateTypeSubject = CurrentValueSubject<(P2PCallState, P2PCallType), Never>((.none, .none))
	lazy var callButtonSubject = CurrentValueSubject<Bool, Never>(p2pCallUseCase.callType == .outcoming)

	private let p2pCallUseCase: P2PCallUseCaseProtocol
	private let factory: CallItemsFactoryProtocol.Type
	let sources: CallViewSourcesable.Type

	private var subscribtions: Set<AnyCancellable> = []

	init(
		userName: String,
		p2pCallUseCase: P2PCallUseCaseProtocol,
		factory: CallItemsFactoryProtocol.Type = CallItemsFactory.self,
		sources: CallViewSourcesable.Type = CallViewSources.self
	) {
		self.userName = userName
		self.p2pCallUseCase = p2pCallUseCase
		self.factory = factory
		self.sources = sources
		makeVideoAudioModels()
	}

	private func makeVideoAudioModels() {
		let audioVideoModels = factory.makeAudioVideoItems(delegate: self)
		videoAudioStackModel = HStackViewModel(viewModels: audioVideoModels)

		let answerEndCallModels = factory.makeAnswerEndCallItems(viewModel: self, delegate: self)
		answerEndCallStackModel = HStackViewModel(viewModels: answerEndCallModels)
	}

	private func configureBindings() {
		p2pCallUseCase.callStateSubject
			.subscribe(on: RunLoop.main)
			.sink { [weak self] state in
				self?.update(state: state)
			}
			.store(in: &subscribtions)
	}

	private func update(state: P2PCallState) {
		callStateTypeSubject.send((state, p2pCallUseCase.callType))
		let isHidden = p2pCallUseCase.callType == .outcoming || state.rawValue > P2PCallState.calling.rawValue
		callButtonSubject.send(isHidden)
	}
}

// MARK: - CallViewModelProtocol

extension CallViewModel: CallViewModelProtocol {

	func controllerDidDisappear() {
		NotificationCenter.default.post(
			name: .callViewDidDisappear,
			object: nil
		)
	}

	func controllerWillAppear() {
		configureBindings()
		NotificationCenter.default.post(
			name: .callViewWillAppear,
			object: nil
		)
	}

	func controllerDidAppear() {
		NotificationCenter.default.post(
			name: .callViewDidAppear,
			object: nil
		)
	}
}

// MARK: - VideoAudioItemsDelegate

extension CallViewModel: VideoAudioItemsDelegate {

	func didTapVideo(button: ViewUpdatable) {
		debugPrint("didTapVideo")
	}

	func didTapMic(button: ViewUpdatable) {
		debugPrint("didTapMic")
		p2pCallUseCase.toggleMuteState()
		button.updateView(isEnabled: p2pCallUseCase.isMuted)
	}

	func didTapSpeaker(button: ViewUpdatable) {
		debugPrint("didTapSpeaker")
		p2pCallUseCase.changeVoiceSpeaker()
		button.updateView(isEnabled: p2pCallUseCase.isVoiceIsSpeaker)
	}

	func didTapAcceptCallButton() {
		debugPrint("didTapAcceptCallButton")
		p2pCallUseCase.answerCall()
	}

	func didTapEndCallButton() {
		debugPrint("didTapEndCallButton")
		p2pCallUseCase.endCall()
	}
}
