import Combine
import SwiftUI

protocol CreateChannelViewModelProtocol: ObservableObject {

    var selectedImage: Binding<UIImage?> { get set }

    var selectedImg: UIImage? { get set }

    var channelName: Binding<String> { get set }

    var channelDescription: Binding<String> { get set }

    var channelType: ChannelType { get set }

    var resources: CreateChannelResourcable.Type { get }

    func onChannelCreate()

    func isCreateButtonEnabled() -> Bool

    func isDescriptionPlaceholderEnabled() -> Bool
}

final class CreateChannelViewModel: ObservableObject {

    lazy var selectedImage: Binding<UIImage?> = .init(
        get: {
            self.selectedImg
        },
        set: { newValue in
            self.selectedImg = newValue
        }
    )

    var selectedImg: UIImage?

    var channelType: ChannelType = .publicChannel {
        didSet {
            debugPrint("channel type: \(channelType)")
            self.objectWillChange.send()
        }
    }

    private var channelNameText: String = "" {
        didSet {
            self.objectWillChange.send()
        }
    }

    lazy var channelName: Binding<String> = .init(
        get: {
            self.channelNameText
        },
        set: { newValue in
            self.channelNameText = newValue
        }
    )

    private var channelDescriptionText: String = "" {
        didSet {
            self.objectWillChange.send()
        }
    }

    lazy var channelDescription: Binding<String> = .init(
        get: {
            self.channelDescriptionText
        },
        set: { newValue in
            self.channelDescriptionText = newValue
        }
    )

    var coordinator: ChatCreateFlowCoordinatorProtocol
    let resources: CreateChannelResourcable.Type
    private let matrixUseCase: MatrixUseCaseProtocol

    init(
        channelType: ChannelType = .publicChannel,
        matrixUseCase: MatrixUseCaseProtocol = MatrixUseCase.shared,
        coordinator: ChatCreateFlowCoordinatorProtocol,
        resources: CreateChannelResourcable.Type = CrateChannelResources.self
    ) {
        self.resources = resources
        self.channelType = channelType
        self.matrixUseCase = matrixUseCase
        self.coordinator = coordinator
    }
}

// MARK: - CreateChannelViewModelProtocol

extension CreateChannelViewModel: CreateChannelViewModelProtocol {

    func isCreateButtonEnabled() -> Bool {
        !channelNameText.isEmpty
    }

    func isDescriptionPlaceholderEnabled() -> Bool {
        !channelDescriptionText.isEmpty
    }

    func onChannelCreate() {
        matrixUseCase.createChannel(
            name: channelNameText,
            topic: channelDescriptionText,
            channelType: channelType,
            roomAvatar: selectedImg
        ) { state, mxRoomId in
            debugPrint("MATRIX DEBUG matrixUseCase.createGroupRoom: \(mxRoomId)")
            switch state {
            case .roomCreateError:
                break
            case .roomCreateSucces:
                self.coordinator.toParentCoordinator()
            default:
                break
            }
        }
    }
}
