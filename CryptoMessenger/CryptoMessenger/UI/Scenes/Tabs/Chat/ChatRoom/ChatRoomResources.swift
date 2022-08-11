import SwiftUI

// MARK: - ChatRoomSourcesable

protocol ChatRoomSourcesable {

    // MARK: - Static Properties

    // Images
    static var backButton: Image { get }

    static var settingsButton: Image { get }
    
    static var phoneButton: Image { get }
    
    static var plus: Image { get }

    // Text
    static var chatNewRequest: String { get }

    static var joinChat: String { get }

    static var callListAlertActionOne: String { get }

    static var photoEditorTitle: String { get }

    static var chatOnline: String { get }

    static var chatOffline: String { get }

    static var chatRoomViewSelfAvatarChangeNotify: String { get }

    static var chatRoomViewEncryptedMessagesNotify: String { get }

    static var chatRoomViewAvatarChangeNotify: String { get }

    static var chatRoomViewRoomEntryNotify: String { get }

    static var chatRoomViewLeftTheRoomNotify: String { get }

    static var chatRoomViewInvitedNotify: String { get }

    static var chatRoomViewUnownedErrorNotify: String { get }

    static var chatRoomViewBannedNotify: String { get }

	static var callFinished: String { get }

	static var callDeclined: String { get }

	static var callMissed: String { get }
}

// MARK: - ChatRoomResources(ChatRoomSourcesable)

enum ChatRoomResources: ChatRoomSourcesable {

    // MARK: - Static Properties

    // Images

    static var backButton: Image {
        R.image.navigation.backButton.image
    }

    static var settingsButton: Image {
        R.image.navigation.settingsButton.image
    }
    
    static var phoneButton: Image {
        R.image.navigation.phoneButton.image
    }
    
    static var plus: Image {
        R.image.chat.plus.image
    }

    // Text

    static var chatNewRequest: String {
        R.string.localizable.chatNewRequest()
    }

    static var joinChat: String {
        R.string.localizable.chatJoinChat()
    }

    static var callListAlertActionOne: String {
        R.string.localizable.callListAlertActionOne()
    }
    
    static var photoEditorTitle: String {
        R.string.localizable.photoEditorTitle()
    }

    static var chatOnline: String {
        R.string.localizable.chatOnline()
    }

    static var chatOffline: String {
        R.string.localizable.chatOffline()
    }
    
    static var chatRoomViewSelfAvatarChangeNotify: String {
        R.string.localizable.chatRoomViewSelfAvatarChangeNotify()
    }
    
    static var chatRoomViewEncryptedMessagesNotify: String {
        R.string.localizable.chatRoomViewEncryptedMessagesNotify()
    }
    
    static var chatRoomViewAvatarChangeNotify: String {
        R.string.localizable.chatRoomViewAvatarChangeNotify()
    }
    
    static var chatRoomViewRoomEntryNotify: String {
        R.string.localizable.chatRoomViewRoomEntryNotify()
    }
    
    static var chatRoomViewLeftTheRoomNotify: String {
        R.string.localizable.chatRoomViewLeftTheRoomNotify()
    }
    
    static var chatRoomViewInvitedNotify: String {
        R.string.localizable.chatRoomViewInvitedNotify()
    }
    
    static var chatRoomViewUnownedErrorNotify: String {
        R.string.localizable.chatRoomViewUnownedErrorNotify()
    }
    
    static var chatRoomViewBannedNotify: String {
        R.string.localizable.chatRoomViewBannedNotify()
    }

	static var callFinished: String {
		R.string.localizable.callsCallFinished()
	}

	static var callDeclined: String {
		R.string.localizable.callsCallDeclined()
	}

	static var callMissed: String {
		R.string.localizable.callsCallMissed()
	}
}
