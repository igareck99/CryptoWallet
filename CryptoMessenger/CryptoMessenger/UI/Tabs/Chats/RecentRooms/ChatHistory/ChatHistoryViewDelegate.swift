import Combine
import SwiftUI

// MARK: - ChatHistoryViewDelegate

protocol ChatHistoryViewDelegate: ObservableObject {

    var isLoading: Bool { get set }

    var isSearching: Bool { get set }

    var resources: ChatHistorySourcesable.Type { get }

    var eventSubject: PassthroughSubject<ChatHistoryFlow.Event, Never> { get }

    func markAllAsRead()

    func fromCurrentSender(room: AuraRoom) -> Bool

    func joinRoom(roomId: String, openChat: Bool)

    func findRooms(
        with filter: String,
        completion: @escaping ([MatrixChannel]) -> Void
    )

    var chatHistoryRooms: [ChatHistoryData] { get }

    var searchText: String { get set }

    var gloabalSearch: [any ViewGeneratable] { get }

    var viewState: ChatHistoryViewState { get set }

    var chatSections: [any ViewGeneratable] { get set }

    func didTapChat(_ data: ChatHistoryData)

    func didSettingsCall(_ data: ChatHistoryData)

    func didTapFindedCell(_ data: MatrixChannel)

    func onAppear()
}
