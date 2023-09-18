import Combine

// MARK: - ChatViewModelProtocol

protocol ChatViewModelProtocol: ObservableObject {

    associatedtype MessageSendable = ChatViewModelSendable

    var isAccessToWrite: Bool { get set }

    var displayItems: [any ViewGeneratable] { get }

    var sources: ChatRoomSourcesable.Type { get }

    var quickAction: QuickActionCurrentUser? { get set }

    var activeEditMessage: RoomEvent? { get set }

    var eventSubject: PassthroughSubject<ChatRoomFlow.Event, Never> { get }

    var inputText: String { get set }

    func showChatRoomMenu()

    func sendAudio(_ record: RecordingDataModel)

    func sendText()
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
    func sendAudio(_ record: RecordingDataModel)
    func sendPhoto(_ image: UIImage)
    func sendVideo(_ url: URL)
    func sendContact(_ contact: Contact)
    func sendMap(_ location: LocationData?)
    func sendFile(_ url: URL)
}
