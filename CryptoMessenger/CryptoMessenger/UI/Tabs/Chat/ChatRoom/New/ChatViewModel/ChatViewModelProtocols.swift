import Combine
import SwiftUI

// MARK: - ChatViewModelProtocol

protocol ChatViewModelProtocol: ObservableObject {

    associatedtype MessageSendable = ChatViewModelSendable

    var isSnackbarPresented: Bool { get set }

    var messageText: String { get set }

    var userHasAccessToMessage: Bool { get set }

    var scroolString: UUID { get set }

    var scrollId: Published<UUID> { get }

    var scrollIdPublisher: Published<UUID>.Publisher { get }

    var displayItems: [any ViewGeneratable] { get }

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
        type: MessageSendType,
        image: UIImage?,
        url: URL?,
        record: RecordingDataModel?,
        location: LocationData?,
        contact: Contact?
    )

    func onNavBarTap(
        chatData: Binding<ChatData>,
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
    func didTapCryptoSend(event: RoomEvent)
}

protocol ChatViewModelSendable {
    func sendPhoto(image: UIImage)
    func sendVideo(url: URL, event: RoomEvent)
    func sendContact(contact: Contact, event: RoomEvent)
    func sendMap(location: LocationData?, event: RoomEvent)
    func sendFile(url: URL, event: RoomEvent)
    func sendText()
    func sendAudio(record: RecordingDataModel)
}
