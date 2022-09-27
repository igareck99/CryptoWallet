import SwiftUI

protocol ChatHistorySourcesable {

	// Images
	static var chatLogo: Image { get }

	static var chatWriteMessage: Image { get }

	static var chatSettings: Image { get }

	static var chatReactionDelete: Image { get }

	static var ellipsisCircle: Image { get }

	static var squareAndPencil: Image { get }

	// Text
	static var searchPlaceholder: String { get }

	static var decline: String { get }

	static var readAll: String { get }

	static var AUR: String { get }

	static var chats: String { get }
}

enum ChatHistorySources: ChatHistorySourcesable {

	// Images
	static var chatLogo: Image {
		R.image.chat.logo.image
	}

	static var chatWriteMessage: Image {
		R.image.chat.writeMessage.image
	}

	static var chatSettings: Image {
		R.image.chat.settings.image
	}

	static var chatReactionDelete: Image {
		R.image.chat.reaction.delete.image
	}

	static var ellipsisCircle: Image {
		Image(systemName: "ellipsis.circle")
	}

	static var squareAndPencil: Image {
		Image(systemName: "square.and.pencil")
	}

	// Text
	static var searchPlaceholder: String {
		R.string.localizable.chatHistorySearchPlaceholder()
	}

	static var decline: String {
		R.string.localizable.chatHistoryDecline()
	}

	static var readAll: String {
		R.string.localizable.chatHistoryReadAll()
	}

	static var AUR: String {
		R.string.localizable.chatHistoryAUR()
	}

	static var chats: String {
		R.string.localizable.chatHistoryChats()
	}
}
