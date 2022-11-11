import SwiftUI

// swiftlint:disable: all

protocol ChatRoomRowViewModelProtocol {

	func makeChatMessageEventView(
		showFile: Binding<Bool>,
		showMap: Binding<Bool>,
		showLocationTransition: Binding<Bool>,
		activateShowCard: Binding<Bool>,
		playingAudioId: Binding<String>,
		onSelectPhoto: GenericBlock<URL?>?,
		onContactButtonAction: @escaping (String, String?, URL?) -> Void,
		onFileTapHandler: @escaping VoidBlock,
		onEmojiTap: @escaping GenericBlock<(emoji: String, messageId: String)>,
		fileSheetPresenting: @escaping (URL?) -> AnyView?,
		message: RoomMessage
	) -> AnyView

	func shouldShowBackground(message: RoomMessage) -> Bool
}

final class ChatRoomRowViewModel {

	private let componentsFactory: ChatComponentsFactoryProtocol

    init(
        componentsFactory: ChatComponentsFactoryProtocol = ChatComponentsFactory()
    ) {
        self.componentsFactory = componentsFactory
	}
}

// MARK: - ChatRoomRowViewModelProtocol

extension ChatRoomRowViewModel: ChatRoomRowViewModelProtocol {

	func makeChatMessageEventView(
		showFile: Binding<Bool>,
		showMap: Binding<Bool>,
		showLocationTransition: Binding<Bool>,
		activateShowCard: Binding<Bool>,
		playingAudioId: Binding<String>,
		onSelectPhoto: GenericBlock<URL?>?,
		onContactButtonAction: @escaping (String, String?, URL?) -> Void,
        onFileTapHandler: @escaping VoidBlock,
		onEmojiTap: @escaping GenericBlock<(emoji: String, messageId: String)>,
        fileSheetPresenting: @escaping (URL?) -> AnyView?,
        message: RoomMessage
    ) -> AnyView {

		componentsFactory.makeChatMessageEventView(
			showFile: showFile,
			showMap: showMap,
			showLocationTransition: showLocationTransition,
			activateShowCard: activateShowCard,
			playingAudioId: playingAudioId,
			onSelectPhoto: onSelectPhoto,
			onContactButtonAction: onContactButtonAction,
			onFileTapHandler: onFileTapHandler,
			onEmojiTap: onEmojiTap,
			fileSheetPresenting: fileSheetPresenting,
            message: message
		)
	}

	func shouldShowBackground(message: RoomMessage) -> Bool {
		switch message.type {
		case .image(_), .location(_), .video(_):
			return false
		default: return true
		}
	}
}
