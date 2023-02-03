import Foundation

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
    
    static var channelType: String { get }
    
    static var leaveChannel: String { get }
    
    static var copyLink: String { get }
    
    static var linkCopied: String { get }
    
    static var lookAll: String { get }
    
    static var participant: String { get }
    
    static var participants: String { get }
    
    static var attachments: String { get }
    
    static var notifications: String { get }
}

enum ChannelInfoResources: ChannelInfoResourcable {
    
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
}
