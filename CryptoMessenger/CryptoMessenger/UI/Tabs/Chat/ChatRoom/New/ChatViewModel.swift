import Foundation

protocol ChatViewModelProtocol: ObservableObject {

    var displayItems: [any ViewGeneratable] { get }

}

final class ChatViewModel {
    @Published var displayItems = [any ViewGeneratable]()
    private let factory: RoomEventsFactory.Type

    init(factory: RoomEventsFactory.Type = RoomEventsFactory.self) {
        self.factory = factory
        displayItems = factory.mockItems
    }
}

// MARK: - ChatViewModelProtocol

extension ChatViewModel: ChatViewModelProtocol {}
