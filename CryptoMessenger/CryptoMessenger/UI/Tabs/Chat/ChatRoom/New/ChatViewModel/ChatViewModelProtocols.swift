import Combine
import SwiftUI

// MARK: - ChatViewModelProtocol

protocol ChatViewModelProtocol: ObservableObject {

    associatedtype MessageSendable = ChatViewModelSendable

    var isAccessToWrite: Bool { get set }
    
    var scrollId: Published<UUID> { get }
    
    var scrollIdPublisher: Published<UUID>.Publisher { get }

    var displayItems: [any ViewGeneratable] { get }
    
    var sendingEventsView: [any ViewGeneratable] { get }

    var sources: ChatRoomSourcesable.Type { get }

    var quickAction: QuickActionCurrentUser? { get set }

    var activeEditMessage: RoomEvent? { get set }

    var eventSubject: PassthroughSubject<ChatRoomFlow.Event, Never> { get }
    
    var participants: [ChannelParticipantsData] { get }
    
    var p2pVideoCallPublisher: ObservableObjectPublisher { get }
    
    var groupCallPublisher: ObservableObjectPublisher { get }
    
    var p2pVoiceCallPublisher: ObservableObjectPublisher { get }
    
    var roomAvatarUrl: URL? { get set }

    var inputText: String { get set }
    
    var chatData: ChatData { get set }
    
    var saveData: Bool { get set }
    
    var replyDescriptionText: String { get set }
    
    var resources: ChatRoomSourcesable.Type { get }
    
    var isChatDirectMenuAvailable: Bool { get set }
    
    var isChatGroupMenuAvailable: Bool { get set }
    
    var isVideoCallAvailablility: Bool { get set }
    
    var isVoiceCallAvailablility: Bool { get set }
    
    var isVideoCallAvailable: Bool { get }
    
    var isVoiceCallAvailable: Bool { get }
    
    var isGroupCall: Bool { get }
    
    var isAvatarLoading: Bool { get set }
    
    var roomName: String { get }
    
    var isDirect: Bool { get }
    
    var isOnline: Bool { get}

    func showChatRoomMenu()
    
    func sendMessage(
        _ type: MessageSendType,
        image: UIImage?,
        url: URL?,
        record: RecordingDataModel?,
        location: LocationData?,
        contact: Contact?
    )
            
    func onNavBarTap(
        chatData: Binding<ChatData>,
        saveData: Binding<Bool>,
        isLeaveChannel: Binding<Bool>
    )
}

// MARK: - ChatEventsDelegate

protocol ChatEventsDelegate {
    func onContactEventTap(contactInfo: ChatContactInfo)
    func onMapEventTap(place: Place)
    func onImageTap(imageUrl: URL?)
    func onCallTap(roomId: String)
    func onDocumentTap(fileUrl: URL, fileName: String)
    func onVideoTap(url: URL)
    func onGroupCallTap(eventId: String)
}


protocol ChatViewModelSendable {
    func sendPhoto(_ image: UIImage)
    func sendVideo(_ url: URL, _ event: RoomEvent)
    func sendContact(_ contact: Contact, _ event: RoomEvent)
    func sendMap(_ location: LocationData?, _ event: RoomEvent)
    func sendFile(_ url: URL, _ event: RoomEvent)
    func sendText()
    func sendAudio(_ record: RecordingDataModel)
}
