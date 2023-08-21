import SwiftUI

// MARK: - ChatGroupViewModel

final class ChatGroupViewModel: ObservableObject {

    var chatData: ChatData
    @Published var titleText = ""
    @Published var descriptionText = ""
    @Injectable private(set) var matrixUseCase: MatrixUseCaseProtocol
    var coordinator: ChatCreateFlowCoordinatorProtocol?
    let resources: ChatGroupResourcable.Type = ChatGroupResources.self

    // MARK: - Lifecycle

    init(
        chatData: ChatData,
        resources: ChatGroupResourcable.Type = ChatGroupResources.self
    ) {
        self.chatData = chatData
    }

    // MARK: - Internal Methods

    func createChat() {
        print("dkasklaskl  \(titleText)")
        chatData.title = titleText
        chatData.description = descriptionText
        print("eklwekwqqwo  \(chatData)")
        matrixUseCase.createGroupRoom(chatData) { result in
            switch result {
            case .roomCreateError:
                break
            case .roomCreateSucces:
                self.coordinator?.toParentCoordinator()
            }
        }
    }
}
