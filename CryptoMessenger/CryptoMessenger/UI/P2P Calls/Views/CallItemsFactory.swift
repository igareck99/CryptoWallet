import Foundation

protocol CallItemsFactoryProtocol {

	// Audio/Video/Mic
	static func makeAudioVideoItems(delegate: VideoAudioItemsDelegate) -> [HStackItemViewModelProtocol]

	static func makeCameraItem(delegate: VideoAudioItemsDelegate) -> HStackItemViewModelProtocol

	static func makeMicItem(delegate: VideoAudioItemsDelegate) -> HStackItemViewModelProtocol

	static func makeSpeakerItem(delegate: VideoAudioItemsDelegate) -> HStackItemViewModelProtocol

	// Answer/End Call
	static func makeAnswerEndCallItems(
		viewModel: CallViewModel,
		delegate: VideoAudioItemsDelegate
	) -> [HStackItemViewModelProtocol]

	static func makeEndCallItem(delegate: VideoAudioItemsDelegate) -> HStackItemViewModelProtocol

	static func makeAnswerCallItem(
		viewModel: CallViewModel,
		delegate: VideoAudioItemsDelegate
	) -> HStackItemViewModelProtocol
}

enum CallItemsFactory { }

// MARK: - CallItemsFactoryProtocol

extension CallItemsFactory: CallItemsFactoryProtocol {

	// MARK: - Audio/Video/Mic

	static func makeAudioVideoItems(delegate: VideoAudioItemsDelegate) -> [HStackItemViewModelProtocol] {
		var items = [HStackItemViewModelProtocol]()

		let cameraItem = makeCameraItem(delegate: delegate)
		items.append(cameraItem)

		let micItem = makeMicItem(delegate: delegate)
		items.append(micItem)

		let speakerItem = makeSpeakerItem(delegate: delegate)
		items.append(speakerItem)

		return items
	}

	static func makeCameraItem(delegate: VideoAudioItemsDelegate) -> HStackItemViewModelProtocol {

		let normalIcon = UIImage(systemName: "video")?.withRenderingMode(.alwaysTemplate)
		let updateView = makeUpdateViewClosure(
			normalText: "Камера",
			disabledText: "Камера",
			normalIcon: normalIcon,
			disabledIcon: normalIcon
		)

		let action: ((ViewUpdatable) -> Void)? = { delegate.didTapVideo(button: $0) }
		let cameraItem = HStackItemViewModel(
			updateView: updateView,
			action: action
		)
		return cameraItem
	}

	static func makeMicItem(delegate: VideoAudioItemsDelegate) -> HStackItemViewModelProtocol {

		let normalIcon = UIImage(systemName: "mic")?.withRenderingMode(.alwaysTemplate)
		let disabledIcon = UIImage(systemName: "mic.slash")?.withRenderingMode(.alwaysTemplate)

		let updateView = makeUpdateViewClosure(
			normalText: "Включить звук",
			disabledText: "Убрать звук",
			normalIcon: normalIcon,
			disabledIcon: disabledIcon
		)

		let action: ((ViewUpdatable) -> Void)? = { delegate.didTapMic(button: $0) }
		let micItem = HStackItemViewModel(
			updateView: updateView,
			action: action
		)
		return micItem
	}

	static func makeSpeakerItem(delegate: VideoAudioItemsDelegate) -> HStackItemViewModelProtocol {

		let normalIcon = UIImage(systemName: "speaker.wave.2")?.withRenderingMode(.alwaysTemplate)
		let disabledIcon = UIImage(systemName: "speaker.slash")?.withRenderingMode(.alwaysTemplate)

		let updateView = makeUpdateViewClosure(
			normalText: "Динамик",
			disabledText: "Динамик",
			normalIcon: normalIcon,
			disabledIcon: disabledIcon
		)

		let action: ((ViewUpdatable) -> Void)? = { delegate.didTapSpeaker(button: $0) }
		let speakerItem = HStackItemViewModel(
			updateView: updateView,
			action: action
		)
		return speakerItem
	}

	// MARK: - Answer/End Call

	static func makeAnswerEndCallItems(
		viewModel: CallViewModel,
		delegate: VideoAudioItemsDelegate
	) -> [HStackItemViewModelProtocol] {
		var items = [HStackItemViewModelProtocol]()

		let endCallItem = makeEndCallItem(delegate: delegate)
		items.append(endCallItem)

		let answerCallItem = makeAnswerCallItem(
			viewModel: viewModel,
			delegate: delegate
		)
		items.append(answerCallItem)

		return items
	}

	static func makeEndCallItem(delegate: VideoAudioItemsDelegate) -> HStackItemViewModelProtocol {

		let normalIcon = UIImage(systemName: "phone.down.fill")?.withRenderingMode(.alwaysTemplate)

		let updateView: ((Bool, ButtonDownText) -> Void)? = { _, view in
			view.actionButton.setImage(normalIcon, for: .normal)
			view.actionButton.tintColor = .white
			view.actionButton.backgroundColor = .systemRed
			view.actionButton.imageView?.contentMode = .scaleAspectFill
			view.actionButton.imageView?.tintColor = .white
			view.actionButton.layer.cornerRadius = 35
		}

		let action: ((ViewUpdatable) -> Void)? = { _ in delegate.didTapEndCallButton() }
		let speakerItem = HStackItemViewModel(
			updateView: updateView,
			action: action
		)
		return speakerItem
	}

	static func makeAnswerCallItem(
		viewModel: CallViewModel,
		delegate: VideoAudioItemsDelegate
	) -> HStackItemViewModelProtocol {

		let normalIcon = UIImage(systemName: "phone.fill")?.withRenderingMode(.alwaysTemplate)

		let updateView: ((Bool, ButtonDownText) -> Void)? = { _, view in
			view.actionButton.setImage(normalIcon, for: .normal)
			view.actionButton.tintColor = .white
			view.actionButton.backgroundColor = .systemGreen
			view.actionButton.imageView?.contentMode = .scaleAspectFill
			view.actionButton.imageView?.tintColor = .white
			view.actionButton.layer.cornerRadius = 35
		}

		let action: ((ViewUpdatable) -> Void)? = { _ in delegate.didTapAcceptCallButton() }
		let speakerItem = HStackItemViewModel(
			updateView: updateView,
			action: action,
			isHidden: viewModel.callButtonSubject.eraseToAnyPublisher()
		)
		return speakerItem
	}

	// MARK: - Helper methods

	private static func makeUpdateViewClosure(
		normalText: String,
		disabledText: String,
		normalIcon: UIImage?,
		disabledIcon: UIImage?
	) -> ((Bool, ButtonDownText) -> Void)? {

		let updateView: ((Bool, ButtonDownText) -> Void)? = { isEnabled, view in
			if isEnabled {
				view.underButtonLabel.text = normalText
				view.actionButton.setImage(disabledIcon, for: .normal)
				view.actionButton.tintColor = .black
				view.actionButton.backgroundColor = .white
			} else {
				view.underButtonLabel.text = disabledText
				view.actionButton.setImage(normalIcon, for: .normal)
				view.actionButton.tintColor = .white
				view.actionButton.backgroundColor = .systemGray
			}
		}
		return updateView
	}
}
