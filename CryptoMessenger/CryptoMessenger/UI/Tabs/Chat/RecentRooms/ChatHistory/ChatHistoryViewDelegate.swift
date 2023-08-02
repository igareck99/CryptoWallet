import SwiftUI
import Combine

// MARK: - ChatHistoryViewDelegate

protocol ChatHistoryViewDelegate: ObservableObject {

    var isLoading: Bool { get set }
    
    var isSearching: Bool { get set }

    var groupAction: GroupAction? { get set }

    var sources: ChatHistorySourcesable.Type { get }

    var eventSubject: PassthroughSubject<ChatHistoryFlow.Event, Never> { get }

    func markAllAsRead()

    func fromCurrentSender(room: AuraRoom) -> Bool

    func joinRoom(_ roomId: String, _ openChat: Bool)

    func findRooms(with filter: String,
                   completion: @escaping ([MatrixChannel]) -> Void)

    var chatHistoryRooms: [ChatHistoryData] { get }

    var searchText: Binding<String> { get set }

    var gloabalSearch: [any ViewGeneratable] { get }  

    var viewState: ChatHistoryViewState { get }

    var chatSections: [any ViewGeneratable] { get }

    func didTapChat(_ data: ChatHistoryData)
    
    func didSettingsCall(_ data: ChatHistoryData)
    
    func didTapFindedCell(_ data: MatrixChannel)
}
