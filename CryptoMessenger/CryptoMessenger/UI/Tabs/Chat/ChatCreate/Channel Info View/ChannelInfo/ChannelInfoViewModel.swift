import Combine
import SwiftUI
import MatrixSDK

// swiftlint: disable: all
// MARK: - ChannelInfoViewModel

final class ChannelInfoViewModel {

    var isAuthorized: Bool {
        getCurrentUserRole() == .admin || getCurrentUserRole() == .owner
    }
    
    var shouldShowDescription: Bool {
        !channelTopic.isEmpty
    }

    @Published var tappedUserId: String = ""
    @Published var showDeleteChannel = false
    @Published var showChangeRole = false
    @Published var showUserProfile = false
    @Published var showUserSettings = false
    @Published var showLeaveChannel = false
    @Published var showSelectOwner = false
    @Published var showSelectCurrentUserRole = false
    @Published var channelTopic = ""
    @Published var roomDisplayName = ""
    @Published var showMakeNewRole = false
    @Published var showMakeRole = false
    @Published var searchText = ""
    @Published var showChannelChangeType = false
    @Published var changeViewEdit = false {
        didSet {
            if changeViewEdit {
                self.setParametrsBeforeChange()
            }
        }
    }
    var leaveChannelText = ""
    var isRoomPublicValue = true
    var isSnackbarPresented = false
    var isChannel: Bool { room.isChannel }
    var shouldChange: Bool = false {
        didSet {
            self.updateRoomParams()
        }
    }
    private var participants = [ChannelParticipantsData]() {
        didSet {
            self.objectWillChange.send()
        }
    }
    
    lazy var roomImageUrl: URL? = matrixUseCase.getRoomAvatarUrl(roomId: room.roomId)
    var roomImage: Image? {
        guard let img = selectedImg else { return nil }
        return Image(uiImage: img)
    }
    @Published var selectedImg: UIImage?

    let room: AuraRoomData
    var coordinator: ChatHistoryFlowCoordinatorProtocol?
    let resources: ChannelInfoResourcable.Type = ChannelInfoResources.self
    private let onInviteUsersToChannelGroup = DispatchGroup()
    private let matrixUseCase: MatrixUseCaseProtocol
    private let factory: ChannelUsersFactoryProtocol.Type
    private var roomPowerLevels: MXRoomPowerLevels?
    private var eventsListener: MXEventListener?
    private let accessService: MediaAccessProtocol & PhotosAccessProtocol
    private var subscriptions = Set<AnyCancellable>()
    private var timeRoomName = ""
    private var timeRoomDescription = ""
    
    var chatData: Binding<ChatData>
    @Binding var saveData: Bool

    init(
        room: AuraRoomData,
        chatData: Binding<ChatData>,
        saveData: Binding<Bool>,
        matrixUseCase: MatrixUseCaseProtocol = MatrixUseCase.shared,
        factory: ChannelUsersFactoryProtocol.Type = ChannelUsersFactory.self,
        accessService: MediaAccessProtocol & PhotosAccessProtocol = AccessService.shared,
        resources: ChannelInfoResourcable.Type = ChannelInfoResources.self
    ) {
        self.room = room
        self.chatData = chatData
        self._saveData = saveData
        self.matrixUseCase = matrixUseCase
        self.factory = factory
        self.accessService = accessService
        self.assignTexts()
        self.getRoomInfo()
        self.loadUsers()
        self.isRoomPublic()
        self.listenEvents()
        
    }
    
    func onAvatarChange() {
        chatData.wrappedValue.image = selectedImg
    }
    
    private func updateRoomParams() {
        print("lsaslaslasl  \(shouldChange)")
        guard shouldChange else {
            channelTopic = timeRoomDescription
            roomDisplayName = timeRoomName
            print("slaslaskl  \(roomDisplayName)  \(channelTopic)")
            return
        }
        if let imgData = self.selectedImg?.jpeg(.medium) {
            matrixUseCase.setRoomAvatar(data: imgData, roomId: room.roomId) { result in
                debugPrint("Channel setRoomAvatar result: \(result)")
            }
        }
        if let room = matrixUseCase.getRoomInfo(roomId: room.roomId) {
            room.setTopic(self.channelTopic) { _ in }
            room.setName(self.roomDisplayName) { _ in }
        }
        shouldChange = false
    }
    
    private func getRoomInfo() {
        if let room = matrixUseCase.getRoomInfo(roomId: room.roomId) {
            roomDisplayName = room.summary?.displayName ?? ""
            channelTopic = room.summary?.topic ?? ""
            objectWillChange.send()
        }
        
        matrixUseCase.getRoomState(roomId: room.roomId) { [weak self] result in
            
            guard let self = self else { return }
            guard case let .success(state) = result else { return }

            debugPrint("roomState result: \(state)")
            debugPrint("roomState power levels result: \(String(describing: state.powerLevels))")
            
            self.roomPowerLevels = state.powerLevels
        }
    }
    
    private func loadUsers() {
        debugPrint("loadUsers")
        matrixUseCase.getRoomMembers(roomId: room.roomId) { [weak self] result in
            guard case let .success(roomMembers) = result else { return }
            debugPrint("getRoomMembers result: \(String(describing:roomMembers.members))")
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                let users: [ChannelParticipantsData] = self.factory.makeUsersData(users: roomMembers.members, roomPowerLevels: self.roomPowerLevels)
                self.participants = users
                self.objectWillChange.send()
            }
        }
    }
    
    private func setParametrsBeforeChange() {
        timeRoomName = roomDisplayName
        timeRoomDescription = channelTopic
    }

    private func updateUser(completion: @escaping () -> Void) {
        matrixUseCase.getRoomMembers(roomId: room.roomId) { [weak self] result in
            guard case let .success(roomMembers) = result else { return }
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                let users: [ChannelParticipantsData] = self.factory.makeUsersData(users: roomMembers.members, roomPowerLevels: self.roomPowerLevels)
                self.participants = users
                self.objectWillChange.send()
                completion()
            }
        }
    }

    private func showProfile() {
        showUserSettings = false
        DispatchQueue.main.async {
            self.onShowUserProfile()
        }
    }
    
    func listenEvents() {
        let room = matrixUseCase.getRoomInfo(roomId: room.roomId)
        room?.liveTimeline { [weak self] liveTimeLine in
            let listener = liveTimeLine?.listenToEvents { [weak self] event, direction, roomState in
                debugPrint("liveTimeLine.listenToEvents: \(event) \(direction) \(String(describing: roomState))")
                debugPrint("liveTimeLine.listenToEvents event.type: \(String(describing: event.type))")
                
                if event.type == "m.room.avatar",
                   let rId = self?.room.roomId {
                    debugPrint("roomImageUrl: \(String(describing: self?.roomImageUrl?.absoluteString))")
                    self?.roomImageUrl = self?.matrixUseCase.getRoomAvatarUrl(roomId: rId)
                    debugPrint("roomImageUrl: \(String(describing: self?.roomImageUrl?.absoluteString))")
                    DispatchQueue.main.async {
                        self?.objectWillChange.send()
                    }
                    return
                }

                if event.type == "m.room.topic",
                   let topic = room?.summary.topic {
                    self?.channelTopic = topic
                    self?.objectWillChange.send()
                    return
                }

                self?.getRoomInfo()
                self?.loadUsers()
            } as? MXEventListener

            self?.eventsListener = listener
        }
    }
    
    private func getRoomAvatarUrl() {
        guard let url = self.matrixUseCase.getRoomAvatarUrl(roomId: self.room.roomId) else { return }
        let config = Configuration.shared
        let homeServer = config.matrixURL
        self.roomImageUrl = MXURL(mxContentURI: url.absoluteString)?.contentURL(on: homeServer)
    }

    func setData() {
        getRoomAvatarUrl()
    }
}

// MARK: - ChannelInfoViewModelProtocol

extension ChannelInfoViewModel: ChannelInfoViewModelProtocol {
    

    func onOpenSettingsTap() {
        guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
        UIApplication.shared.open(url)
    }

    func onCameraPickerTap() -> Bool {
        return accessService.videoAccessLevel == .authorized
    }

    func onMakeRoleTap() {
        self.showSelectOwner = true
    }

    func onMakeCurrentUserRoleTap() {
        showMakeNewRole = false
        self.showSelectCurrentUserRole = true
    }

    func onLeaveChannel() {
           let currentUserId: String = matrixUseCase.getUserId()
           matrixUseCase.getRoomState(roomId: room.roomId) { [weak self] result in
               guard let self = self else { return }
               guard case let .success(state) = result else { return }
               debugPrint("roomState result: \(state)")
               debugPrint("roomState power levels result: \(String(describing: state.powerLevels))")
               guard
                   let currentUserPowerLevel: Int = state.powerLevels?.powerLevelOfUser(withUserID: currentUserId) else {
                   return
               }
               let isOwner: Bool = currentUserPowerLevel == 100
               // Если текущий пользователь не является владельцем канала
               if !isOwner {
                   self.matrixUseCase.updateUserPowerLevel(userId: currentUserId,
                                                           roomId: self.room.roomId,
                                                           powerLevel: 0) { [weak self] _ in
                       self?.onLeaveRoom()
                   }
                   return
               }
               let ownersList = state.members.members
                   .filter { state.powerLevels.powerLevelOfUser(withUserID: $0.userId) == 100 }
               
               let isOnlyOneOwner = ownersList.count == 1
               // Если текущий пользователь не является единственным владельцем канала
               if !isOnlyOneOwner {
                   self.matrixUseCase.updateUserPowerLevel(userId: currentUserId,
                                                           roomId: self.room.roomId,
                                                           powerLevel: 0) { [weak self] _ in
                       self?.onLeaveRoom()
                   }
                   self.onLeaveRoom()
                   return
               }
               self.showMakeRole = true
           }
       }

    
    func nextScene(_ scene: ChannelInfoFlow.Event) {
        switch scene {
        case let .onMedia(roomId):
            guard let auraRoom = matrixUseCase.rooms.first(where: { $0.room.roomId == roomId }) else { return }
            self.coordinator?.chatMedia(room)
        default:
            break
        }
    }

    func onShowUserProfile() {
        guard let user = participants.first(where: { $0.matrixId == tappedUserId }) else { return }
        let contact = Contact(mxId: user.matrixId, avatar: user.avatar, name: user.name, status: user.status, onTap: { _ in
        })
        coordinator?.friendProfile(contact)
    }
    
    func onDeleteChannel() {
        matrixUseCase.leaveRoom(roomId: room.roomId) { result in
            debugPrint("leaveRoom result:\(result)")
        }
    }
    
    func onDeleteAllUsers() {
        let currentUserId: String = matrixUseCase.getUserId()
        participants.forEach {
            guard let matrixId = UserIdValidator.makeValidId(userId: $0.matrixId) else { return }
            guard currentUserId != matrixId, !currentUserId.contains(matrixId), !matrixId.contains(currentUserId) else { return }
            
            debugPrint("\(matrixId)")
            matrixUseCase.kickUser(
                userId: matrixId,
                roomId: room.roomId,
                reason: "kicked"
            ) {
                debugPrint("matrixUseCase.kickUser result: \($0)")
                // TODO: Обработать failure case
                guard case .success = $0 else { return }
                self.onLeaveRoom()
            }
        }
    }
    
    func onRoleSelected(role: ChannelRole,
                        ownerCheck: Bool) {
        guard let matrixId = UserIdValidator.makeValidId(userId: tappedUserId) else { return }
        let adminAmount = participants.filter({ $0.role == .owner }).count
        if ownerCheck {
            if tappedUserId == matrixUseCase.getUserId() && adminAmount == 1 &&
                getUserRole(matrixUseCase.getUserId()) == .owner {
                showMakeNewRole = true
                return
            }
        }
        let group = DispatchGroup()
        group.enter()
        matrixUseCase.updateUserPowerLevel(
            userId: tappedUserId,
            roomId: room.roomId,
            powerLevel: role.powerLevel
        ) { _ in
            group.leave()
        }
        group.notify(queue: .main) {
            self.loadUsers()
        }
    }
    
    private func assignTexts() {
        roomDisplayName = room.roomName
        if room.isChannel {
            leaveChannelText = resources.leaveChannel
        } else {
            leaveChannelText = "Выйти из чата"
        }
    }
    
    func onAssignAnotherOwners(users: [ChannelParticipantsData],
                               newRole: ChannelRole?,
                               completion: @escaping () -> Void) {
        guard let role = newRole else { return }
        let group = DispatchGroup()
        if users.count > 1 {
            group.enter()
            var userIds = users.map { data in
                if let id = UserIdValidator.makeValidId(userId: data.matrixId) {
                    return id
                } else {
                    return ""
                }
            }
            userIds = userIds.filter({ !$0.isEmpty })
            matrixUseCase.updateUsersPowerLevel(userIds: userIds,
                                                roomId: self.room.roomId,
                                                powerLevel: ChannelRole.owner.powerLevel) { [weak self] _ in
                group.leave()
            }
        } else {
            users.forEach {
                group.enter()
                guard let matrixId = UserIdValidator.makeValidId(userId: $0.matrixId) else { return }
                matrixUseCase.updateUserPowerLevel(
                    userId: matrixId,
                    roomId: room.roomId,
                    powerLevel: ChannelRole.owner.powerLevel
                ) { [weak self] _ in
                    group.leave()
                }
            }
        }
        group.notify(queue: .main) {
            self.tappedUserId = self.matrixUseCase.getUserId()
            self.onRoleSelected(role: role,
                                ownerCheck: false)
            completion()
        }
    }

    func showNotifications() {
        self.coordinator?.notifications(room.roomId)
    }

    func onInviteUsersToChannel(users: [Contact]) {
        
        for user in users {
            onInviteUsersToChannelGroup.enter()
            matrixUseCase.inviteUser(userId: user.mxId, roomId: room.roomId) { [weak self] result in
                // TODO: Обработать failure case
               
                guard let self = self, case .success = result else { return }
                
                self.matrixUseCase.updateUserPowerLevel(userId: user.mxId,
                                                        roomId: self.room.roomId,
                                                        powerLevel: 0) { [weak self] _ in
                    self?.onInviteUsersToChannelGroup.leave()
                }
            }
        }
        onInviteUsersToChannelGroup.notify(queue: .main) {
            self.loadUsers()
        }
    }

    func onUserRemoved() {
        loadUsers()
    }

    func onChannelLinkCopy() {
        isSnackbarPresented = true
        objectWillChange.send()
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
            self?.isSnackbarPresented = false
            self?.objectWillChange.send()
        }
    }

    func onDeleteUserFromChannel() {
        matrixUseCase.kickUser(
            userId: "",
            roomId: "",
            reason: ""
        ) { result in
            debugPrint("onDeleteUserFromChannel: \(result)")
        }
    }

    func onInviteUserToChannel() {
        matrixUseCase.inviteUser(
            userId: "",
            roomId: ""
        ) { result in
            debugPrint("onInviteUserToChannel: \(result)")
        }
    }
    
    func onAssignNewOwners(users: [ChannelParticipantsData],
                           completion: @escaping () -> Void) {
        let group = DispatchGroup()
        if users.isEmpty {
            return
        }
        users.forEach {
            group.enter()
            guard let matrixId = UserIdValidator.makeValidId(userId: $0.matrixId) else { return }
            debugPrint("\(matrixId)")
            matrixUseCase.updateUserPowerLevel(
                userId: matrixId,
                roomId: room.roomId,
                powerLevel: ChannelRole.owner.powerLevel
            ) { [weak self] _ in
                group.leave()
                completion()
                self?.onLeaveRoom()
            }
        }
        group.notify(queue: .main) {
            completion()
            self.onLeaveRoom()
        }
    }

    func onBanUserFromChannel() {
        matrixUseCase.banUser(
            userId: "",
            roomId: "",
            reason: ""
        ) { result in
            debugPrint("onDeleteUserFromChannel: \(result)")
        }
    }

    func onUnbanUserFromChannel() {
        matrixUseCase.unbanUser(
            userId: "",
            roomId: ""
        ) { result in
            debugPrint("onDeleteUserFromChannel: \(result)")
        }
    }

    func onLeaveRoom() {
        matrixUseCase.leaveRoom(roomId: room.roomId) { [weak self] _ in
            guard let self = self else { return }
            self.loadUsers()
            self.coordinator?.popToRoot()
        }
    }

    func getChannelUsers() -> [ChannelParticipantsData] {
        participants
    }
    
    func getChannelUsersFiltered() -> [ChannelParticipantsData] {
        if searchText.isEmpty {
            return participants
        }
        return participants.filter({ $0.name.contains(self.searchText) })
    }
    
    func getCurrentUserRole() -> ChannelRole {
        return factory.detectUserRole(userId: matrixUseCase.getUserId(),
                                          roomPowerLevels: roomPowerLevels)
    }
    
    func getUserRole(_ userId: String) -> ChannelRole {
        return factory.detectUserRole(userId: userId,
                                      roomPowerLevels: roomPowerLevels)
    }
    
    func updateUserRole(mxId: String, userRole: ChannelRole) {
        debugPrint("Role of \(mxId)  is updated to \(userRole)")
    }
    
    func isRoomPublic() {
        let group = DispatchGroup()
        group.enter()
        matrixUseCase.isRoomPublic(roomId: room.roomId) { value in
            self.isRoomPublicValue = value ?? false
            group.leave()
        }
        group.notify(queue: .main) {
            self.objectWillChange.send()
        }
    }
    
    func compareRoles() -> ChannelUserActions {
        let selectedUserRole = factory.detectUserRole(userId: tappedUserId,
                                                      roomPowerLevels: roomPowerLevels)
        let currentUserRole = factory.detectUserRole(userId: matrixUseCase.getUserId(),
                                                      roomPowerLevels: roomPowerLevels)
        if tappedUserId == matrixUseCase.getUserId() {
            return ChannelUserActions(true, false)
        }
        if selectedUserRole == .owner && currentUserRole == .owner {
            return ChannelUserActions(false, false)
        }
        if currentUserRole.powerLevel > selectedUserRole.powerLevel {
            return ChannelUserActions(true, true)
        } else {
            return ChannelUserActions(false, false)
        }
    }
    
    func showParticipantsView(_ viewModel: ChannelInfoViewModel,
                              _ showParticipants: Binding<Bool>) {
        self.coordinator?.channelPatricipantsView(viewModel,
                                                  showParticipantsView: showParticipants)
    }
    
    func dismissSheet() {
        self.coordinator?.dismissCurrentSheet()
    }
    
    func selectPhoto(_ sourceType: UIImagePickerController.SourceType) {
        self.coordinator?.galleryPickerFullScreen(sourceType: sourceType,
                                                   galleryContent: .all, onSelectImage: { image in
            if let image = image {
                self.selectedImg = image
            }
        }, onSelectVideo: { _ in
        })
    }
}

// MARK: - ChannelUserActions

struct ChannelUserActions {

    let changeRole: Bool
    let delete: Bool

    // MARK: - Lifecycle
    
    init(_ changeRole: Bool,
         _ delete: Bool) {
        self.changeRole = changeRole
        self.delete = delete
    }
}
