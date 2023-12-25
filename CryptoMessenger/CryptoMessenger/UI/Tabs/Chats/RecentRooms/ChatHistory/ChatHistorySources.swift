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
    
    //Color
    static var titleColor: Color { get }
    
    static var buttonBackground: Color { get }
    
    static var textColor: Color { get }
    
    static var background: Color { get }
    
    static var textBoxBackground: Color { get }
    
    static var tintColor: Color { get }
    
    static var negativeColor: Color { get }
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
		R.image.chat.messageMenu.trash.image
	}

	static var ellipsisCircle: Image {
        R.image.chatHistory.chatHistorysettings.image
	}

	static var squareAndPencil: Image {
        R.image.chatHistory.createChat.image
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
    
    //Colors
    static var titleColor: Color {
        .chineseBlack
    }
    
    static var buttonBackground: Color {
        .dodgerBlue
    }
    
    static var textColor: Color {
        .romanSilver
    }
    
    static var background: Color {
        .white 
    }
    
    static var textBoxBackground: Color {
        .aliceBlue
    }
    
    static var tintColor: Color {
        .romanSilver01
    }
    
    static var negativeColor: Color {
        .spanishCrimson
    }
}
