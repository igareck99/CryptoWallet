import Combine

// MARK: - ChatViewModelProtocol

protocol ChatViewModelProtocol: ObservableObject {

    associatedtype MessageSendable = ChatViewModelSendable

    var isAccessToWrite: Bool { get set }
    
    var scrollId: Published<UUID> { get }
    
    var scrollIdPublisher: Published<UUID>.Publisher { get }

    var displayItems: [any ViewGeneratable] { get set }
    
    var sendingEventsView: [any ViewGeneratable] { get }

    var sources: ChatRoomSourcesable.Type { get }

    var quickAction: QuickActionCurrentUser? { get set }

    var activeEditMessage: RoomEvent? { get set }

    var eventSubject: PassthroughSubject<ChatRoomFlow.Event, Never> { get }

    var inputText: String { get set }

    func showChatRoomMenu()
    
    func sendMessage(_ type: MessageSendType,
                     image: UIImage?,
                     url: URL?,
                     record: RecordingDataModel?,
                     location: LocationData?,
                     contact: Contact?)
}

// MARK: - ChatEventsDelegate

protocol ChatEventsDelegate {
    func onContactEventTap(contactInfo: ChatContactInfo)
    func onMapEventTap(place: Place)
    func onImageTap(imageUrl: URL?)
    func onCallTap(roomId: String)
    func onDocumentTap(fileUrl: URL, fileName: String)
    func onVideoTap(url: URL)
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
