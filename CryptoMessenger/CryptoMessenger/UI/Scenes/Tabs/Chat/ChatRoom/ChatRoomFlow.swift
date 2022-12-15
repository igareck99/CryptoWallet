import Foundation
import UIKit
import SwiftUI

// MARK: - ChatRoomFlow

enum ChatRoomFlow {

    // MARK: - ViewState

    enum ViewState {

        // MARK: - Types

        case idle
        case loading
        case error(message: String)
    }

    // MARK: - Event

    enum Event {

        // MARK: - Types

        case onAppear
        case onSendText(String)
        case onSendImage(UIImage)
        case onSendFile(URL)
        case onSendAudio(URL, Int)
        case onSendContact(Contact)
        case onReply(String, String)
        case onEdit(String, String)
        case onDelete(String)
        case onSendLocation(LocationData)
        case onJoinRoom
        case onAddReaction(messageId: String, reactionId: String)
        case onDeleteReaction(messageId: String, reactionId: String)
        case onNextScene
        case onSettings(chatData: Binding<ChatData>, saveData: Binding<Bool>, room: AuraRoom)
        case onSendVideo(_ url: URL)
        case onMedia(_ room: AuraRoom)
    }
}
