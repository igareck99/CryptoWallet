import SwiftUI

// MARK: - ChatSettingsViewModel

final class ChatSettingsViewModel: ObservableObject {

    // MARK: - Internal properties

    var room: AuraRoomData
    var coordinator: ChatHistoryFlowCoordinatorProtocol
    @Published var actionState: ChatSettingsActionState = .leaveChat
    @Published var name = ""
    @Published var roomNameLetters = ""
    @Published var changeViewEdit = false
    @Published var showActionSheet = false
    @Published var selectedImg: UIImage?
    @Published var roomName: String = ""
    @Published var roomTopic: String = ""
    @Published var roomImageUrl: URL?
    @Published var roomIsEncrypted = true
    var shouldChange: Bool = false {
        didSet {
            self.updateRoomParams()
        }
    }
    let resources: ChannelInfoResourcable.Type
    let matrixUseCase: MatrixUseCaseProtocol
    private let accessService: MediaAccessProtocol & PhotosAccessProtocol
    private let config: ConfigType

    // MARK: - Lifecycle

    init(room: AuraRoomData,
         coordinator: ChatHistoryFlowCoordinatorProtocol,
         matrixUseCase: MatrixUseCaseProtocol = MatrixUseCase.shared,
         config: ConfigType = Configuration.shared,
         accessService: MediaAccessProtocol & PhotosAccessProtocol = AccessService.shared,
         resources: ChannelInfoResourcable.Type = ChannelInfoResources.self) {
        self.matrixUseCase = matrixUseCase
        self.room = room
        self.coordinator = coordinator
        self.resources = resources
        self.config = config
        self.accessService = accessService
        self.onAppear()
    }

    func changeScreen(_ isEdit: Bool) {
        withAnimation(.linear(duration: 0.35)) {
            changeViewEdit = isEdit
        }
    }

    func onOpenSettingsTap() {
        guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
        UIApplication.shared.open(url)
    }
    
    func onCameraPickerTap() -> Bool {
        return accessService.videoAccessLevel == .authorized
    }
    
    func selectPhoto(_ sourceType: UIImagePickerController.SourceType) {
        self.coordinator.galleryPickerFullScreen(sourceType: sourceType,
                                                   galleryContent: .all, onSelectImage: { image in
            if let image = image {
                self.selectedImg = image
            }
        }, onSelectVideo: { _ in
        })
    }
    
    func blockUser() {
        
    }
    
    private func updateRoomParams() {
        guard shouldChange else { return }
        shouldChange = false
        if let room = matrixUseCase.getRoomInfo(roomId: room.roomId) {
            room.setTopic(self.roomTopic) { _ in }
            room.setName(self.roomName) { _ in }
        }
        guard let image = self.selectedImg?.jpeg(.medium) else { return }
        matrixUseCase.setRoomAvatar(data: image, roomId: room.roomId) { result in
            debugPrint("Channel setRoomAvatar result: \(result)")
        }
    }

    func onMedia() {
        coordinator.chatMedia(room: room)
    }

    func onNotifications() {
        coordinator.notifications(roomId: room.roomId)
    }

    func onLeaveRoom() {
        matrixUseCase.leaveRoom(roomId: room.roomId) { [weak self] _ in
            guard let self = self else { return }
            self.coordinator.popToRoot()
        }
    }

    private func getRoomAvatarUrl(_ url: URL?) {
        guard let url = self.matrixUseCase.getRoomAvatarUrl(roomId: url?.absoluteString ?? "") else { return }
        let homeServer = self.config.matrixURL
        self.room.roomAvatar = MXURL(mxContentURI: url.absoluteString)?.contentURL(on: homeServer)
        self.roomImageUrl = MXURL(mxContentURI: url.absoluteString)?.contentURL(on: homeServer)
    }

    private func onAppear() {
        guard let user = room.participants.first(where: { $0.matrixId != matrixUseCase.getUserId() }) else { return }
        getRoomAvatarUrl(user.avatar)
        self.roomName = user.name
        self.roomNameLetters = self.roomName[0]
        self.roomTopic = user.matrixId
        self.roomImageUrl = user.avatar
    }
}

enum ChatSettingsActionState {
    case blockUser
    case leaveChat
}
