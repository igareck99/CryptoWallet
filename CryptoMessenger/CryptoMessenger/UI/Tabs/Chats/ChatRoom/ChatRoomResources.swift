import SwiftUI

// MARK: - ChatRoomSourcesable

protocol ChatRoomSourcesable {

    // MARK: - Static Properties

    // Images
    static var backButton: Image { get }

    static var settingsButton: Image { get }

    static var phoneButton: Image { get }

    static var plus: Image { get }
    
    static var video: Image { get }

    static var phone: Image { get }

    static var videoFill: Image { get }

    static var phoneFill: Image { get }

    static var paperPlane: Image { get }

    // Text
    static var chatNewRequest: String { get }

    static var joinChat: String { get }

    static var callListAlertActionOne: String { get }

    static var photoEditorTitle: String { get }

    static var chatOnline: String { get }

    static var chatOffline: String { get }

    static var chatRoomViewSelfAvatarChange: String { get }

    static var chatRoomViewEncryptedMessages: String { get }

    static var chatRoomViewAvatarChange: String { get }

    static var chatRoomViewRoomEntry: String { get }

    static var chatRoomViewLeftTheRoom: String { get }

    static var chatRoomViewInvited: String { get }

    static var chatRoomViewUnownedError: String { get }

    static var chatRoomViewBanned: String { get }
    
    static var chatRoomViewJoined: String { get }

	static var callFinished: String { get }

	static var callDeclined: String { get }

	static var callMissed: String { get }

    static var acceptTheInvitation: String { get }

    static var join: String { get }

    static var translateChange: String { get }

    static var translate: String { get }

    static var translateIntoRussian: String { get }

    static var translateAlertEncryption: String { get }

	static var groupCallActiveConference: String { get }

	static var groupCallInactiveConference: String { get }
    
    static var noRightsToWriteChannel: String { get }
    
    static var inputViewPlaceholder: String { get }
    
    //Colors
    static var backgroundFodding: Color { get }
    
    static var background: Color { get }
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

    static var videoFill: Image {
        Image(systemName: "video.fill")
    }

    static var phoneFill: Image {
        Image(systemName: "phone.fill")
    }

    static var paperPlane: Image {
        R.image.chat.send.image
    }
    
    static var video: Image { 
        Image(systemName: "video")
    }

    static var phone: Image { 
        Image(systemName: "phone")
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

    static var chatRoomViewSelfAvatarChange: String {
        R.string.localizable.chatRoomViewSelfAvatarChangeNotify()
    }

    static var chatRoomViewEncryptedMessages: String {
        R.string.localizable.chatRoomViewEncryptedMessagesNotify()
    }

    static var chatRoomViewAvatarChange: String {
        R.string.localizable.chatRoomViewAvatarChangeNotify()
    }

    static var chatRoomViewRoomEntry: String {
        R.string.localizable.chatRoomViewRoomEntryNotify()
    }

    static var chatRoomViewLeftTheRoom: String {
        R.string.localizable.chatRoomViewLeftTheRoomNotify()
    }

    static var chatRoomViewInvited: String {
        R.string.localizable.chatRoomViewInvitedNotify()
    }

    static var chatRoomViewUnownedError: String {
        R.string.localizable.chatRoomViewUnownedErrorNotify()
    }

    static var chatRoomViewBanned: String {
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

    static var acceptTheInvitation: String {
        R.string.localizable.chatAcceptTheInvitation()
    }

    static var join: String {
        R.string.localizable.chatJoin()
    }

    static var translateChange: String {
        R.string.localizable.translateChange()
    }

    static var translate: String {
        R.string.localizable.translateTranslate()
    }

    static var translateIntoRussian: String {
        R.string.localizable.translateIntoRussian()
    }

    static var translateAlertEncryption: String {
        R.string.localizable.translateAlertEncryption()
    }

	static var groupCallActiveConference: String {
		R.string.localizable.groupCallActiveConference()

	}

	static var groupCallInactiveConference: String {
		R.string.localizable.groupCallInactiveConference()
	}
    
    static var chatRoomViewJoined: String {
        "присоединился к комнате"
    }
    static var noRightsToWriteChannel: String {
        "У вас нет разрешения на публикацию в этом канале"
    }
    
    static var inputViewPlaceholder: String {
        "Сообщение..."
    }
    
    //Colors
    static var backgroundFodding: Color {
        .chineseBlack04
    }
    
    static var background: Color {
        .white 
    }
}
