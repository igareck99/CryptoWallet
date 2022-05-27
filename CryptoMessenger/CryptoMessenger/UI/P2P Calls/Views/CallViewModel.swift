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
	var p2pCallType: P2PCallType { get }
	var videoAudioStackModel: HStackViewModel? { get }
	var answerEndCallStackModel: HStackViewModel? { get }
	var p2pCallStateTypePublisher: Published<(P2PCallState, P2PCallType)>.Publisher { get }

	func controllerDidDisappear()
}

final class CallViewModel {

	let userName: String
	let screenTitle: String = "Защищено сквозным шифрованием"
	let p2pCallType: P2PCallType
	var videoAudioStackModel: HStackViewModel?
	var answerEndCallStackModel: HStackViewModel?

	@Published var p2pCallStateType: (P2PCallState, P2PCallType) = (.ringing, .incoming)
	var p2pCallStateTypePublisher: Published<(P2PCallState, P2PCallType)>.Publisher { $p2pCallStateType }

	lazy var callButtonSubject = CurrentValueSubject<Bool, Never>(p2pCallType == .outcoming)
	private let p2pCallUseCase: P2PCallUseCaseProtocol
	private let factory: CallItemsFactoryProtocol.Type
	let sources: CallViewSourcesable.Type

	init(
		userName: String,
		p2pCallType: P2PCallType,
		p2pCallUseCase: P2PCallUseCaseProtocol,
		factory: CallItemsFactoryProtocol.Type = CallItemsFactory.self,
		sources: CallViewSourcesable.Type = CallViewSources.self
	) {
		self.userName = userName
		self.p2pCallType = p2pCallType
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
}

// MARK: - CallViewModelProtocol

extension CallViewModel: CallViewModelProtocol {

	func controllerDidDisappear() {
		p2pCallUseCase.endCall()
	}
}

// MARK: - P2PCallUseCaseDelegate

extension CallViewModel: P2PCallUseCaseDelegate {
	func callDidChange(state: P2PCallState) {
		p2pCallStateType = (state, p2pCallType)
		let isHidden = p2pCallType == .outcoming || state.rawValue > P2PCallState.calling.rawValue
		callButtonSubject.send(isHidden)
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
