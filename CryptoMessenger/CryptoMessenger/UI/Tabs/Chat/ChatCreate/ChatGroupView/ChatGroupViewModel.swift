import SwiftUI
import Combine

// MARK: - ChatGroupViewModel

final class ChatGroupViewModel: ObservableObject {

    var chatData = ChatData.emptyObject()
    var navBarTitle = ""
    var textEditorDescription = ""
    @Published var titleText = ""
    @Published var isSnackbarPresented = false
    @Published var snackBarText = ""
    @Published var shackBarColor: Color = .green
    @Published var descriptionText = ""
    @Published var isEncryptionEnable = false
    @Published var selectedImg: UIImage?
    @Published var channelType: ChannelType = .publicChannel
    var type: CreateGroupCases
    @Injectable private(set) var matrixUseCase: MatrixUseCaseProtocol
    var coordinator: ChatCreateFlowCoordinatorProtocol?
    let resources: ChatGroupResourcable.Type = ChatGroupResources.self
    private var subscriptions = Set<AnyCancellable>()

    // MARK: - Lifecycle

    init(
        type: CreateGroupCases = .groupChat,
        resources: ChatGroupResourcable.Type = ChatGroupResources.self
    ) {
        self.type = type
        self.initLabels()
        self.bindInput()
    }

    func onCreate() {
        if type == .channel {
            onChannelCreate()
        } else {
            createChat()
        }
    }

    // MARK: - Internal Methods
    
    private func showSnackBar(_ text: String,
                              _ color: Color) {
        snackBarText = text
        shackBarColor = color
        isSnackbarPresented = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
            withAnimation(.linear(duration: 0.25)) {
                self?.isSnackbarPresented = false
            }
        }
    }

    private func createChat() {
//        chatData.title = titleText
//        chatData.description = descriptionText
//        chatData.image = selectedImg
//        let result = RoomCreateState.roomAlreadyExist
//        self.showSnackBar(result.rawValue,
//                          result.color)
        matrixUseCase.createGroupRoom(chatData) { result in
            switch result {
            case .roomCreateError, .roomAlreadyExist:
                self.showSnackBar(result.rawValue,
                                  result.color)
            case .roomCreateSucces:
                self.coordinator?.toParentCoordinator()
            }
        }
    }

    private func onChannelCreate() { 
//        let result = RoomCreateState.roomCreateError
//        self.showSnackBar(result.rawValue,
//                          result.color)
        matrixUseCase.createChannel(name: titleText, topic: descriptionText,
                                    channelType: channelType, roomAvatar: selectedImg) { result in
            switch result {
            case .roomCreateError, .roomAlreadyExist:
                self.showSnackBar(result.rawValue,
                                  result.color)
            case .roomCreateSucces:
                self.coordinator?.toParentCoordinator()
                self.coordinator = nil
            }
        }
    }
    
    private func bindInput() {
    }

    // MARK: - Private Methods

    private func initLabels() {
        if type == .groupChat {
            navBarTitle = R.string.localizable.chatMenuViewGroupName()
            textEditorDescription = R.string.localizable.chatCreateGroupAdditionalInfoTitle()
        } else {
            navBarTitle = R.string.localizable.createActionCreateChannel()
            textEditorDescription = R.string.localizable.createChannelDescription()
        }
    }
}

// MARK: - CreateGroupCases

enum CreateGroupCases {
    case channel
    case groupChat
}
