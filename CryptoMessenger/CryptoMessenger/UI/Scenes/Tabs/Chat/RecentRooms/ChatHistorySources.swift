import SwiftUI

protocol ChatHistorySourcesable {

	// Images
	static var chatLogo: Image { get }

	static var chatWriteMessage: Image { get }

	static var chatSettings: Image { get }

	static var chatReactionDelete: Image { get }

	static var ellipsisCircle: Image { get }

	static var squareAndPencil: Image { get }

    static var noDataImage: Image { get }
    
    static var emptyState: Image { get }

	// Text
	static var searchPlaceholder: String { get }

	static var decline: String { get }

	static var readAll: String { get }

	static var AUR: String { get }

	static var chats: String { get }

    static var searchEmpty: String { get }

    static var enterData: String { get }

    static var noResult: String { get }

    static var nothingFind: String { get }

    static var globalSearch: String { get }
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

    static var noDataImage: Image {
        R.image.chatHistory.nodata.image
    }

    static var emptyState: Image {
        R.image.chatHistory.emptyState.image
    }

	// Text
	static var searchPlaceholder: String {
		R.string.localizable.chatHistorySearchPlaceholder()
	}

	static var decline: String {
        R.string.localizable.photoEditorAlertCancel()
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

    static var searchEmpty: String {
        R.string.localizable.chatHistorySearchEmpty()
    }

    static var enterData: String {
        R.string.localizable.chatHistoryEnterData()
    }

    static var noResult: String {
        R.string.localizable.chatHistoryNoResult()
    }

    static var nothingFind: String {
        R.string.localizable.chatHistoryNothingFind()
    }

    static var globalSearch: String {
        R.string.localizable.chatHistoryGlobalSearch()
    }
}
