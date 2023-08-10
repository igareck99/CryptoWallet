import Combine

// MARK: - ChatHistoryViewDelegate

protocol ChatHistoryViewDelegate: ObservableObject {

    var rooms: [AuraRoom] { get }
    
    var isLoading: Bool { get set }

    var groupAction: GroupAction? { get set }

    var sources: ChatHistorySourcesable.Type { get }

    var eventSubject: PassthroughSubject<ChatHistoryFlow.Event, Never> { get }

    func rooms(with filter: String) -> [ChatHistoryData]

    func markAllAsRead()
    
    func fromCurrentSender(room: AuraRoom) -> Bool
    
    func joinRoom(_ roomId: String, _ openChat: Bool)
    
    func findRooms(with filter: String,
                   completion: @escaping ([MatrixChannel]) -> Void)
    
    var chatHistoryRooms: [ChatHistoryData] { get }
    
    func onAppear()
}
