import Combine
import SwiftUI
import MatrixSDK

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
    private let matrixUseCase: MatrixUseCaseProtocol

    let resources: CreateChannelResourcable.Type
    
    
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
        let parameters = MXRoomCreationParameters()
        parameters.inviteArray = []
        parameters.isDirect = false
        parameters.name = channelNameText
        parameters.topic = channelDescriptionText
        if channelType == .publicChannel {
            parameters.visibility = MXRoomDirectoryVisibility.public.identifier
        } else {
            parameters.visibility = MXRoomDirectoryVisibility.private.identifier
        }
        parameters.preset = MXRoomPreset.privateChat.identifier
        let powerLevelOverride = MXRoomPowerLevels()
        powerLevelOverride.eventsDefault = 50
        powerLevelOverride.stateDefault = 50
        powerLevelOverride.usersDefault = 0
        powerLevelOverride.invite = 50
        parameters.powerLevelContentOverride = powerLevelOverride
        createRoom(parameters: parameters, roomAvatar: selectedImg?.jpeg(.medium))
        coordinator.toParentCoordinator()
    }

    private func createRoom(parameters: MXRoomCreationParameters, roomAvatar: Data? = nil) {
        matrixUseCase.createRoom(parameters: parameters) { [weak self] response in
            switch response {
            case let .success(room):
                let inviteType = self?.channelType == .publicChannel ? true : false
                self?.matrixUseCase.setJoinRule(roomId: room.roomId,
                                                isPublic: inviteType,
                                                completion: { _ in
                })
                guard let data = roomAvatar else {
                    return
                }

                self?.matrixUseCase.setRoomAvatar(data: data, for: room) { _ in
                    // TODO: Обработать case failure
                }
            case.failure:
                debugPrint("channel creation failure")
            }
        }
    }
}
