import Foundation
import UIKit

protocol CallItemsFactoryProtocol {

	// Hold
	static func makeHoldItems(
		viewModel: CallViewModel,
		delegate: VideoAudioItemsDelegate
	) -> [HStackItemViewModelProtocol]

	static func makeHoldCallItem(
		viewModel: CallViewModel,
		delegate: VideoAudioItemsDelegate
	) -> HStackItemViewModelProtocol

	static func makeChangeHoldedCallItem(
		viewModel: CallViewModel,
		delegate: VideoAudioItemsDelegate
	) -> HStackItemViewModelProtocol

	// Audio/Video/Mic
	static func makeAudioVideoItems(
		viewModel: CallViewModel,
		delegate: VideoAudioItemsDelegate
	) -> [HStackItemViewModelProtocol]

	// Camera Item
	static func makeCameraItem(
		delegate: VideoAudioItemsDelegate,
		sources: CallViewSourcesable.Type
	) -> HStackItemViewModelProtocol

	// Mic Item
	static func makeMicItem(
		delegate: VideoAudioItemsDelegate,
		sources: CallViewSourcesable.Type
	) -> HStackItemViewModelProtocol

	// Speaker Item
	static func makeSpeakerItem(
		delegate: VideoAudioItemsDelegate,
		sources: CallViewSourcesable.Type
	) -> HStackItemViewModelProtocol

	// Answer/End Call
	static func makeAnswerEndCallItems(
		viewModel: CallViewModel,
		delegate: VideoAudioItemsDelegate
	) -> [HStackItemViewModelProtocol]

	// End Call
	static func makeEndCallItem(delegate: VideoAudioItemsDelegate) -> HStackItemViewModelProtocol

	// Answer Call
	static func makeAnswerCallItem(
		viewModel: CallViewModel,
		delegate: VideoAudioItemsDelegate
	) -> HStackItemViewModelProtocol

	// Decline And Answer Call
	static func makeDeclineAndAnswerCallItem(
		viewModel: CallViewModel,
		delegate: VideoAudioItemsDelegate
	) -> HStackItemViewModelProtocol

	// Hold And Answer Call
	static func makeHoldAndAnswerCallItem(
		viewModel: CallViewModel,
		delegate: VideoAudioItemsDelegate
	) -> HStackItemViewModelProtocol
}

enum CallItemsFactory { }

// MARK: - CallItemsFactoryProtocol

extension CallItemsFactory: CallItemsFactoryProtocol {

	// MARK: - Audio/Video/Mic

	static func makeAudioVideoItems(
		viewModel: CallViewModel,
		delegate: VideoAudioItemsDelegate
	) -> [HStackItemViewModelProtocol] {
		var items = [HStackItemViewModelProtocol]()

		// TODO: Сделать видеозвонки
//		let cameraItem = makeCameraItem(delegate: delegate)
//		items.append(cameraItem)
		let changeHoldCallItem = makeChangeHoldedCallItem(viewModel: viewModel, delegate: delegate)
		items.append(changeHoldCallItem)

		let holdCallItem = makeHoldCallItem(viewModel: viewModel, delegate: delegate)
		items.append(holdCallItem)

		let micItem = makeMicItem(delegate: delegate, sources: viewModel.sources)
		items.append(micItem)

		let speakerItem = makeSpeakerItem(delegate: delegate, sources: viewModel.sources)
		items.append(speakerItem)

		return items
	}

	static func makeCameraItem(
		delegate: VideoAudioItemsDelegate,
		sources: CallViewSourcesable.Type
	) -> HStackItemViewModelProtocol {

		let normalIcon = UIImage(systemName: "video")?.withRenderingMode(.alwaysTemplate)
		let updateView = makeUpdateViewClosure(
			normalText: sources.camera,
			disabledText: sources.camera,
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

	static func makeMicItem(
		delegate: VideoAudioItemsDelegate,
		sources: CallViewSourcesable.Type
	) -> HStackItemViewModelProtocol {

        let normalIcon = sources.soundOnImage
		let disabledIcon = sources.soundOffImage

		let updateView = makeUpdateViewClosure(
			normalText: sources.turnOnSound,
			disabledText: sources.turnOffSound,
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

	static func makeSpeakerItem(
		delegate: VideoAudioItemsDelegate,
		sources: CallViewSourcesable.Type
	) -> HStackItemViewModelProtocol {

		let normalIcon = sources.dynamicSoundOn
        let disabledIcon = sources.dynamicSoundOff

		let updateView = makeUpdateViewClosure(
			normalText: sources.speaker,
			disabledText: sources.speaker,
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

		// Принимаем звонки через экран CallKit
		/*
		let answerCallItem = makeAnswerCallItem(
			viewModel: viewModel,
			delegate: delegate
		)
		items.append(answerCallItem)
		 */

		return items
	}

	static func makeEndCallItem(delegate: VideoAudioItemsDelegate) -> HStackItemViewModelProtocol {

        let imgName = R.image.callScreen.endCall.name
		let normalIcon = UIImage(named: imgName)

		let updateView: ((Bool, ButtonDownText) -> Void)? = { _, view in
            view.actionButton.clipCorners(radius: 34)
			view.actionButton.setImage(normalIcon, for: .normal)
            view.actionButton.backgroundColor = UIColor(.red2323098())
			view.actionButton.imageView?.contentMode = .scaleAspectFill
			view.actionButton.imageView?.tintColor = .white
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

		let imgName = R.image.callList.acceptCall.name
		let normalIcon = UIImage(named: imgName)

		let updateView: ((Bool, ButtonDownText) -> Void)? = { _, view in
			view.actionButton.setImage(normalIcon, for: .normal)
			view.actionButton.tintColor = .white
			view.actionButton.backgroundColor = .systemGreen
			view.actionButton.imageView?.contentMode = .scaleAspectFill
			view.actionButton.imageView?.tintColor = .white
		}

		let action: ((ViewUpdatable) -> Void)? = { _ in delegate.didTapAcceptCallButton() }
		let speakerItem = HStackItemViewModel(
			updateView: updateView,
			action: action,
			isHidden: viewModel.callButtonSubject.eraseToAnyPublisher()
		)
		return speakerItem
	}

	static func makeDeclineAndAnswerCallItem(
		viewModel: CallViewModel,
		delegate: VideoAudioItemsDelegate
	) -> HStackItemViewModelProtocol {

		let imgName = R.image.callList.declineAndAccept.name
		let normalIcon = UIImage(named: imgName)
		let updateView: ((Bool, ButtonDownText) -> Void)? = { _, view in
			view.actionButton.setImage(normalIcon, for: .normal)
			view.actionButton.imageView?.contentMode = .scaleAspectFill
			view.actionButton.backgroundColor = .clear
		}

		let action: ((ViewUpdatable) -> Void)? = { _ in delegate.didTapAcceptCallButton() }
		let item = HStackItemViewModel(
			updateView: updateView,
			action: action,
			isHidden: viewModel.endAndAcceptCallButtonSubject.eraseToAnyPublisher()
		)
		return item
	}

	static func makeHoldAndAnswerCallItem(
		viewModel: CallViewModel,
		delegate: VideoAudioItemsDelegate
	) -> HStackItemViewModelProtocol {

		let imgName = R.image.callList.holdAndAccept.name
		let normalIcon = UIImage(named: imgName)
		let updateView: ((Bool, ButtonDownText) -> Void)? = { _, view in
			view.actionButton.setImage(normalIcon, for: .normal)
			view.actionButton.imageView?.contentMode = .scaleAspectFill
			view.actionButton.backgroundColor = .clear
		}

		let action: ((ViewUpdatable) -> Void)? = { _ in delegate.didTapAcceptCallButton() }
		let item = HStackItemViewModel(
			updateView: updateView,
			action: action,
			isHidden: viewModel.holdAndAcceptCallButtonSubject.eraseToAnyPublisher()
		)
		return item
	}

	// MARK: - Hold item

	static func makeHoldItems(
		viewModel: CallViewModel,
		delegate: VideoAudioItemsDelegate
	) -> [HStackItemViewModelProtocol] {
		var items = [HStackItemViewModelProtocol]()

		// TODO: Изменить логику
//		let changeHoldCallItem = makeChangeHoldedCallItem(viewModel: viewModel, delegate: delegate)
//		items.append(changeHoldCallItem)

		return items
	}

	static func makeHoldCallItem(
		viewModel: CallViewModel,
		delegate: VideoAudioItemsDelegate
	) -> HStackItemViewModelProtocol {

		let normalIcon = UIImage(systemName: "pause.fill")?.withRenderingMode(.alwaysTemplate)
		let updateView = makeUpdateViewClosure(
			normalText: "",
			disabledText: "",
			normalIcon: normalIcon,
			disabledIcon: normalIcon
		)

		let action: ((ViewUpdatable) -> Void)? = { delegate.didTapHoldCallButton(button: $0) }
		let item = HStackItemViewModel(
			updateView: updateView,
			action: action,
			isHidden: viewModel.holdCallButtonSubject.eraseToAnyPublisher(),
			isButtonEnabled: viewModel.holdCallButtonActiveSubject.eraseToAnyPublisher()
		)
		return item
	}

	static func makeChangeHoldedCallItem(
		viewModel: CallViewModel,
		delegate: VideoAudioItemsDelegate
	) -> HStackItemViewModelProtocol {

		let normalText = viewModel.sources.changeInterlocutor
		let normalIcon = UIImage(systemName: "arrow.triangle.2.circlepath")?.withRenderingMode(.alwaysTemplate)
		let updateView: ((Bool, ButtonDownText) -> Void)? = { _, view in
			view.actionButton.setImage(normalIcon, for: .normal)
			view.actionButton.imageView?.contentMode = .scaleAspectFill
			view.underButtonLabel.text = normalText
			view.actionButton.tintColor = .black
			view.actionButton.backgroundColor = .white
		}

		let action: ((ViewUpdatable) -> Void)? = { delegate.didTapChangeHoldedCallButton(button: $0) }
		let item = HStackItemViewModel(
			updateView: updateView,
			action: action,
			isHidden: viewModel.changeHoldedCallButtonSubject.eraseToAnyPublisher(),
			isButtonEnabled: viewModel.changeHoldedCallButtonActiveSubject.eraseToAnyPublisher()
		)
		return item
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
                view.actionButton.backgroundColor = UIColor(.grayA5A4A7())
			}
		}
		return updateView
	}
}
