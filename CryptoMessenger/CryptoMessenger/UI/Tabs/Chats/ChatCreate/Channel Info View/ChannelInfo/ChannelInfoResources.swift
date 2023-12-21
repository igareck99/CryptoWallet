import Foundation
import SwiftUI

// swiftlint: disable: all

protocol ChannelInfoResourcable {
    
    static var docsWillBe: String { get }

    static var noDocs: String { get }
    
    static var mediaWillBe: String { get }
    
    static var noMedia: String { get }
    
    static var channelMedia: String { get }
    
    static var change: String { get }
    
    static var add: String { get }
    
    static var deleteChannel: String { get }
    
    static var privateChannel: String { get }
    
    static var publicChannel: String { get }
    
    static var channelType: String { get }
    
    static var leaveChannel: String { get }
    
    static var copyLink: String { get }
    
    static var linkCopied: String { get }
    
    static var lookAll: String { get }
    
    static var participant: String { get }
    
    static var participants: String { get }
    
    static var attachments: String { get }
    
    static var notifications: String { get }
    
    static var presentationCancel: String { get }
    
    static var rightButton: String { get }
    
    static var profileFromGallery: String { get }
    
    static var profileFromCamera: String { get }
    
    static var snackbarBackground: Color { get }
    
    static var blockUserDescription: String { get }
    
    static var blockUser: String { get }
    
    static var blockTitle: String { get }
    
    static var removeChat: String { get }
    
    static var removeChatDescription: String { get }
    
    static var background: Color { get }
    
    static var textBoxBackground: Color { get }
    
    static var logoBackground: Color { get }
    
    static var titleColor: Color { get }
    
    static var textColor: Color { get }
    
    static var avatarColor: Color { get }
    
    static var negativeColor: Color { get}
    
    static var buttonBackground: Color { get }
}

enum ChannelInfoResources: ChannelInfoResourcable {
    
    static var rightButton: String {
        R.string.localizable.profileDetailRightButton()
    }
    
    static var presentationCancel: String {
        R.string.localizable.personalizationCancel()
    }
    
    static var docsWillBe: String {
        R.string.localizable.channelInfoDocsWillBe()
    }

    static var noDocs: String {
        R.string.localizable.channelInfoNoDocs()
    }
    
    static var mediaWillBe: String {
        R.string.localizable.channelInfoMediaWillBe()
    }
    
    static var noMedia: String {
        R.string.localizable.channelInfoNoMedia()
    }
    
    static var channelMedia: String {
        R.string.localizable.channelInfoChannelMedia()
    }
    
    static var change: String {
        R.string.localizable.channelInfoChange()
    }
    
    static var add: String {
        R.string.localizable.channelInfoAdd()
    }
    
    static var publicChannel: String {
        return "Публичный"
    }
    
    static var blockUser: String {
        R.string.localizable.chatSettingsBlockUser()
    }
    
    static var deleteChannel: String {
        R.string.localizable.channelInfoDeleteChannel()
    }
    
    static var privateChannel: String {
        R.string.localizable.channelInfoPrivateChannel()
    }
    
    
    static var channelType: String {
        R.string.localizable.channelInfoChannelType()
    }
    
    static var leaveChannel: String {
        R.string.localizable.channelInfoLeaveChannel()
    }
    
    static var copyLink: String {
        R.string.localizable.channelInfoCopyLink()
    }
    
    static var linkCopied: String {
        R.string.localizable.channelInfoLinkCopied()
    }
    
    static var lookAll: String {
        R.string.localizable.channelInfoLookAll()
    }
    
    static var participant: String {
        R.string.localizable.channelInfoParticipant()
    }
    
    static var participants: String {
        R.string.localizable.channelInfoParticipants()
    }
    
    static var attachments: String {
        R.string.localizable.channelInfoAttachments()
    }
    
    static var notifications: String {
        R.string.localizable.channelInfoNotifications()
    }
    
    static var profileFromGallery: String {
        R.string.localizable.profileFromGallery()
    }
    
    static var profileFromCamera: String {
        R.string.localizable.profileFromCamera()
    }
    
    static var snackbarBackground: Color {
            .greenCrayola
    }
    
    static var background: Color {
        .white
    }
    
    static var textBoxBackground: Color {
        .dodgerBlue
    }
    
    static var logoBackground: Color {
        .dodgerTransBlue
    }
    
    static var titleColor: Color {
        .chineseBlack
    }
    
    static var textColor: Color {
        .romanSilver
    }
    
    static var negativeColor: Color {
        .spanishCrimson
    }
    
    static var buttonBackground: Color {
        .dodgerBlue
    }
    
    static var avatarColor: Color {
        .diamond
    }
    
    static var blockUserDescription: String {
        R.string.localizable.chatSettingsBlockUserDescription()
    }
    
    static var blockTitle: String {
        R.string.localizable.chatSettingsBlockUser()
    }
    
    static var removeChat: String {
        R.string.localizable.chatHistoryRemove()
    }
    
    static var removeChatDescription: String {
        R.string.localizable.chatSettingsRemoveChatDescription()
    }
}
