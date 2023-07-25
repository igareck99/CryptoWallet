import SwiftUI

// MARK: - ChatGroupViewModel

final class ChatGroupViewModel: ObservableObject {

    @Binding var chatData: ChatData
    @Published var titleText = ""
    @Published var descriptionText = ""
    @Injectable private(set) var matrixUseCase: MatrixUseCaseProtocol
    var coordinator: ChatCreateFlowCoordinatorProtocol?
    @State var isRoomCreated = false
    let resources: ChatGroupResourcable.Type = ChatGroupResources.self
    
    // MARK: - Lifecycle
    
    init(
        chatData: Binding<ChatData>,
        resources: ChatGroupResourcable.Type = ChatGroupResources.self
    ) {
        self._chatData = chatData
    }
    
    // MARK: - Internal Methods
    
    func createChat() {
        isRoomCreated = true
        chatData.title = titleText
        chatData.description = descriptionText
        createGroupRoom()
    }
    
    // MARK: - Private Methods
    
    private func createGroupRoom() {
        let parameters = MXRoomCreationParameters()
        parameters.inviteArray = chatData.contacts.map({ $0.mxId })
        parameters.isDirect = false
        parameters.name = chatData.title
        parameters.topic = chatData.description
        parameters.visibility = MXRoomDirectoryVisibility.private.identifier
        parameters.preset = MXRoomPreset.privateChat.identifier
        createRoom(parameters: parameters,
                   roomAvatar: chatData.image?.jpeg(.medium))
    }

    private func createRoom(parameters: MXRoomCreationParameters,
                            roomAvatar: Data? = nil) {
        matrixUseCase.createRoom(parameters: parameters) { [weak self] response in
            switch response {
            case let .success(room):
                guard let data = roomAvatar else {
                    self?.coordinator?.toParentCoordinator()
                    return
                }
                self?.matrixUseCase.setRoomAvatar(data: data, for: room) { _ in
                    // TODO: Обработать case failure
                }
                self?.coordinator?.toParentCoordinator()
            case .failure:
                self?.coordinator?.toParentCoordinator()
            }
        }
    }

}
