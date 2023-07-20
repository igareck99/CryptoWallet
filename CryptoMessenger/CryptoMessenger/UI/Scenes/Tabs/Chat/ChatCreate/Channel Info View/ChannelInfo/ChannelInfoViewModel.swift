import Combine
import SwiftUI
import MatrixSDK

// swiftlint: disable: all

// MARK: - ChannelInfoViewModelProtocol

protocol ChannelInfoViewModelProtocol: ObservableObject {
    
    var chatData: Binding<ChatData> { get set }

    var selectedImg: UIImage? { get set }
    
    var roomImageUrl: URL? { get }
    
    var roomImage: Image? { get }
    
    var shouldShowDescription: Bool { get }
    
    var isAuthorized: Bool { get }

    var roomId: String { get }
    
    var dissappearScreen: Bool { get set }
    
    var roomDisplayName: String { get }
    
    var isRoomPublicValue: Bool { get set }
    
    var shouldChange: Bool { get set }
    
    var channelTopic: Binding<String> { get set }
   
    var channelName: Binding<String> { get set }
    
    var channelTopicText: String { get set }
   
    var channelNameText: String { get set }
    
    var showMakeRole: Binding<Bool> { get set }
    
    var showMakeNewRole: Binding<Bool> { get set }
    
    var showLeaveChannel: Binding<Bool> { get set }

    var showUserSettings: Binding<Bool> { get set }

    var showChangeRole: Binding<Bool> { get set }

    var showDeleteChannel: Binding<Bool> { get set }

    var tappedUserId: Binding<String> { get set }

    var showUserProfile: Binding<Bool> { get set }
    
    var showSelectOwner: Binding<Bool> { get set }
    
    var showSelectCurrentUserRole: Binding<Bool> { get set }

    var isSnackbarPresented: Bool { get set }

    func onChannelLinkCopy()

    func onDeleteUserFromChannel()

    func onInviteUserToChannel()

    func onInviteUsersToChannel(users: [Contact])
    
    func onAssignNewOwners(users: [ChannelParticipantsData],
                           completion: @escaping () -> Void)

    func onBanUserFromChannel()

    func onUnbanUserFromChannel()

    func getChannelUsers() -> [ChannelParticipantsData]

    func updateUserRole(mxId: String, userRole: ChannelRole)

    func onUserRemoved()

    func onRoleSelected(role: ChannelRole, ownerCheck: Bool)

    func onDeleteAllUsers()
    
    func showNotifications()

    func onDeleteChannel()

    func onShowUserProfile()
    
    func onLeaveChannel()
    
    func nextScene(_ scene: ChannelInfoFlow.Event)
    
    func onMakeRoleTap()
    
    func onMakeCurrentUserRoleTap()
    
    func getCurrentUserRole() -> ChannelRole
    
    func getUserRole(_ userId: String) -> ChannelRole
    
    func compareRoles() -> ChannelUserActions
    
    func isRoomPublic()
    
    func onAvatarChange()
    
    func onCameraPickerTap() -> Bool
    
    func onOpenSettingsTap()
    
    func onAssignAnotherOwners(users: [ChannelParticipantsData],
                               newRole: ChannelRole?,
                               completion: @escaping () -> Void)
    
    func showParticipantsView(_ viewModel: ChannelInfoViewModel,
                              _ showParticipants: Binding<Bool>)
    
    func dismissSheet()
    
    func selectPhoto(_ sourceType: UIImagePickerController.SourceType)
}

// MARK: - ChannelInfoViewModel

final class ChannelInfoViewModel {

    var isAuthorized: Bool {
        getCurrentUserRole() == .admin || getCurrentUserRole() == .owner
    }
    
    var shouldShowDescription: Bool {
        !channelTopicText.isEmpty
    }
    
    private var tappedUserIdText = ""

    lazy var tappedUserId: Binding<String> = .init(
        get: {
            self.tappedUserIdText
        },
        set: { newValue in
            self.tappedUserIdText = newValue
            self.objectWillChange.send()
        }
    )

    private var showDeleteChannelState: Bool = false {
        didSet {
            self.objectWillChange.send()
        }
    }

    lazy var showDeleteChannel: Binding<Bool> = .init(
        get: {
            self.showDeleteChannelState
        },
        set: { newValue in
            self.showDeleteChannelState = newValue
        }
    )

    private var showChangeRoleState: Bool = false {
        didSet {
            self.objectWillChange.send()
        }
    }

    lazy var showChangeRole: Binding<Bool> = .init(
        get: {
            self.showChangeRoleState
        },
        set: { newValue in
            self.showChangeRoleState = newValue
        }
    )

    private var showUserProfileState: Bool = false {
        didSet {
            self.objectWillChange.send()
        }
    }

    lazy var showUserProfile: Binding<Bool> = .init(
        get: {
            self.showUserProfileState
        },
        set: { newValue in
            self.showUserProfileState = newValue
            
            if newValue == true {
                self.showProfile()
            }
        }
    )
    
    private var showUserSettingsState: Bool = false {
        didSet {
            self.objectWillChange.send()
        }
    }
    
    lazy var showUserSettings: Binding<Bool> = .init(
        get: {
            self.showUserSettingsState
        },
        set: { newValue in
            self.showUserSettingsState = newValue
        }
    )
    
    private var showLeaveChannelState: Bool = false {
        didSet {
            self.objectWillChange.send()
        }
    }
    
    lazy var showLeaveChannel: Binding<Bool> = .init(
        get: {
            self.showLeaveChannelState
        },
        set: { newValue in
            self.showLeaveChannelState = newValue
        }
    )
    
    private var showSelectOwnerState: Bool = false {
        didSet {
            self.objectWillChange.send()
        }
    }
    
    private var showSelectCurrentUserRoleState: Bool = false {
        didSet {
            self.objectWillChange.send()
        }
    }
    
    var dissappearScreen: Bool = false
    
    lazy var showSelectOwner: Binding<Bool> = .init(
        get: {
            self.showSelectOwnerState
        },
        set: { newValue in
            self.showSelectOwnerState = newValue
        }
    )

    lazy var showSelectCurrentUserRole: Binding<Bool> = .init(
        get: {
            self.showSelectCurrentUserRoleState
        },
        set: { newValue in
            self.showSelectCurrentUserRoleState = newValue
        }
    )
    
    var channelTopicText: String = "" {
        didSet {
            self.objectWillChange.send()
        }
    }
    
    lazy var channelTopic: Binding<String> = .init(
        get: {
            self.channelTopicText
        },
        set: { newValue in
            self.channelTopicText = newValue
        }
    )
    
    var channelNameText: String = "" {
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
    
    var shouldChange: Bool = false {
        didSet {
            self.updateRoomParams()
        }
    }
    
    private var showMakeRoleState: Bool = false {
        didSet {
            self.objectWillChange.send()
        }
    }
    
    private var showMakeNewRoleState: Bool = false {
        didSet {
            self.objectWillChange.send()
        }
    }
    
    lazy var showMakeNewRole: Binding<Bool> = .init(
        get: {
            self.showMakeNewRoleState
        },
        set: { newValue in
            self.showMakeNewRoleState = newValue
        }
    )
    
    lazy var showMakeRole: Binding<Bool> = .init(
        get: {
            self.showMakeRoleState
        },
        set: { newValue in
            self.showMakeRoleState = newValue
        }
    )
    
    var isRoomPublicValue = true

    var isSnackbarPresented = false

    private var participants = [ChannelParticipantsData]() {
        didSet {
            self.objectWillChange.send()
        }
    }
    
    lazy var roomImageUrl: URL? = matrixUseCase.getRoomAvatarUrl(roomId: roomId)
    var roomImage: Image? {
        guard let img = selectedImg else { return nil }
        return Image(uiImage: img)
    }
    
    var roomDisplayName: String {
        let room = matrixUseCase.getRoomInfo(roomId: roomId)
        let firstLetter = room?.summary.displayName.firstLetter ?? ""
        return firstLetter
    }
    
    lazy var selectedImage: Binding<UIImage?> = .init(
        get: {
            self.selectedImg
        },
        set: { newValue in
            self.selectedImg = newValue
        }
    )

    var selectedImg: UIImage? {
        didSet {
            self.objectWillChange.send()
        }
    }
    
    let roomId: String
    var coordinator: ChatHistoryFlowCoordinatorProtocol?
    private let onInviteUsersToChannelGroup = DispatchGroup()
    private let matrixUseCase: MatrixUseCaseProtocol
    private let factory: ChannelUsersFactoryProtocol.Type
    private var roomPowerLevels: MXRoomPowerLevels?
    private var eventsListener: MXEventListener?
    private let accessService: MediaAccessProtocol & PhotosAccessProtocol
    
    var chatData: Binding<ChatData>
    @Binding var saveData: Bool

    init(
        roomId: String,
        chatData: Binding<ChatData>,
        saveData: Binding<Bool>,
        matrixUseCase: MatrixUseCaseProtocol = MatrixUseCase.shared,
        factory: ChannelUsersFactoryProtocol.Type = ChannelUsersFactory.self,
        accessService: MediaAccessProtocol & PhotosAccessProtocol = AccessService.shared
    ) {
        self.roomId = roomId
        self.chatData = chatData
        self._saveData = saveData
        self.matrixUseCase = matrixUseCase
        self.factory = factory
        self.accessService = accessService
        self.getRoomInfo()
        self.loadUsers()
        self.isRoomPublic()
        self.listenEvents()
    }
    
    func onAvatarChange() {
        chatData.wrappedValue.image = selectedImg
    }
    
    private func updateRoomParams() {
        
        guard shouldChange else { return }
        
        shouldChange = false
        if let imgData = chatData.wrappedValue.image?.jpeg(.medium) {
            matrixUseCase.setRoomAvatar(data: imgData, roomId: roomId) { result in
                debugPrint("Channel setRoomAvatar result: \(result)")
            }
        }
        if let room = matrixUseCase.getRoomInfo(roomId: roomId) {
            room.setTopic(self.channelTopic.wrappedValue) { _ in }
            room.setName(self.channelNameText) { _ in }
        }
        
    }
    
    private func getRoomInfo() {
        if let room = matrixUseCase.getRoomInfo(roomId: roomId) {
            channelNameText = room.summary?.displayName ?? ""
            channelTopicText = room.summary?.topic ?? ""
            objectWillChange.send()
        }
        
        matrixUseCase.getRoomState(roomId: roomId) { [weak self] result in
            
            guard let self = self else { return }
            guard case let .success(state) = result else { return }

            debugPrint("roomState result: \(state)")
            debugPrint("roomState power levels result: \(String(describing: state.powerLevels))")
            
            self.roomPowerLevels = state.powerLevels
        }
    }
    
    private func loadUsers() {
        
        debugPrint("loadUsers")
        
        matrixUseCase.getRoomMembers(roomId: roomId) { [weak self] result in
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

    private func updateUser(completion: @escaping () -> Void) {
        matrixUseCase.getRoomMembers(roomId: roomId) { [weak self] result in
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
        showUserSettingsState = false
        DispatchQueue.main.async {
            self.onShowUserProfile()
        }
    }
    
    func listenEvents() {
        let room = matrixUseCase.getRoomInfo(roomId: roomId)
        room?.liveTimeline { [weak self] liveTimeLine in
            let listener = liveTimeLine?.listenToEvents { [weak self] event, direction, roomState in
                debugPrint("liveTimeLine.listenToEvents: \(event) \(direction) \(String(describing: roomState))")
                debugPrint("liveTimeLine.listenToEvents event.type: \(String(describing: event.type))")
                
                if event.type == "m.room.avatar",
                   let rId = self?.roomId {
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
                    self?.channelTopicText = topic
                    self?.objectWillChange.send()
                    return
                }

                if event.type == "m.room.name",
                   let displayname = room?.summary.displayName {
                    self?.channelNameText = displayname
                    self?.objectWillChange.send()
                    return
                }

                self?.getRoomInfo()
                self?.loadUsers()
            } as? MXEventListener

            self?.eventsListener = listener
        }
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
        self.showSelectOwner.wrappedValue = true
    }

    func onMakeCurrentUserRoleTap() {
        showMakeNewRole.wrappedValue = false
        self.showSelectCurrentUserRole.wrappedValue = true
    }

    func onLeaveChannel() {
               
           let currentUserId: String = matrixUseCase.getUserId()

           matrixUseCase.getRoomState(roomId: roomId) { [weak self] result in

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
                                                           roomId: self.roomId,
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
                                                           roomId: self.roomId,
                                                           powerLevel: 0) { [weak self] _ in
                       self?.onLeaveRoom()
                   }
                   self.onLeaveRoom()
                   return
               }

               self.showMakeRole.wrappedValue = true
           }
       }

    
    func nextScene(_ scene: ChannelInfoFlow.Event) {
        switch scene {
        case let .onMedia(roomId):
            guard let auraRoom = matrixUseCase.rooms.first(where: { $0.room.roomId == roomId }) else { return }
            print("sklasklaskkasl")
            self.coordinator?.chatMedia(auraRoom)
        default:
            break
        }
    }

    func onShowUserProfile() {
        guard let user = participants.first(where: { $0.matrixId == tappedUserIdText }) else { return }
        let contact = Contact(mxId: user.matrixId, avatar: user.avatar, name: user.name, status: user.status)
        coordinator?.friendProfile(contact)
    }
    
    func onDeleteChannel() {
        matrixUseCase.leaveRoom(roomId: roomId) { result in
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
                roomId: roomId,
                reason: "kicked"
            ) {
                debugPrint("matrixUseCase.kickUser result: \($0)")
                // TODO: Обработать failure case
                guard case .success = $0 else { return }
            }
        }
    }
    
    func onRoleSelected(role: ChannelRole,
                        ownerCheck: Bool) {
        guard let matrixId = UserIdValidator.makeValidId(userId: tappedUserIdText) else { return }
        let adminAmount = participants.filter({ $0.role == .owner }).count
        if ownerCheck {
            if tappedUserIdText == matrixUseCase.getUserId() && adminAmount == 1 &&
                getUserRole(matrixUseCase.getUserId()) == .owner {
                showMakeNewRole.wrappedValue = true
                return
            }
        }
        let group = DispatchGroup()
        group.enter()
        matrixUseCase.updateUserPowerLevel(
            userId: tappedUserIdText,
            roomId: roomId,
            powerLevel: role.powerLevel
        ) { _ in
            group.leave()
        }
        group.notify(queue: .main) {
            self.loadUsers()
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
                                                roomId: self.roomId,
                                                powerLevel: ChannelRole.owner.powerLevel) { [weak self] _ in
                group.leave()
            }
        } else {
            users.forEach {
                group.enter()
                guard let matrixId = UserIdValidator.makeValidId(userId: $0.matrixId) else { return }
                matrixUseCase.updateUserPowerLevel(
                    userId: matrixId,
                    roomId: roomId,
                    powerLevel: ChannelRole.owner.powerLevel
                ) { [weak self] _ in
                    group.leave()
                }
            }
        }
        group.notify(queue: .main) {
            self.tappedUserIdText = self.matrixUseCase.getUserId()
            self.onRoleSelected(role: role,
                                ownerCheck: false)
            completion()
        }
    }

    func showNotifications() {
        self.coordinator?.notifications(roomId)
    }

    func onInviteUsersToChannel(users: [Contact]) {
        
        for user in users {
            onInviteUsersToChannelGroup.enter()
            matrixUseCase.inviteUser(userId: user.mxId, roomId: roomId) { [weak self] result in
                // TODO: Обработать failure case
               
                guard let self = self, case .success = result else { return }
                
                self.matrixUseCase.updateUserPowerLevel(userId: user.mxId,
                                                        roomId: self.roomId,
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
        users.forEach {
            group.enter()
            guard let matrixId = UserIdValidator.makeValidId(userId: $0.matrixId) else { return }
            debugPrint("\(matrixId)")
            matrixUseCase.updateUserPowerLevel(
                userId: matrixId,
                roomId: roomId,
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
        matrixUseCase.leaveRoom(roomId: roomId) { [weak self] _ in
            guard let self = self else { return }
            self.loadUsers()
            self.dissappearScreen = true
        }
    }

    func getChannelUsers() -> [ChannelParticipantsData] {
        participants
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
        matrixUseCase.isRoomPublic(roomId: roomId) { value in
            self.isRoomPublicValue = value ?? false
            group.leave()
        }
        group.notify(queue: .main) {
            self.objectWillChange.send()
        }
    }
    
    func compareRoles() -> ChannelUserActions {
        let selectedUserRole = factory.detectUserRole(userId: tappedUserIdText,
                                                      roomPowerLevels: roomPowerLevels)
        let currentUserRole = factory.detectUserRole(userId: matrixUseCase.getUserId(),
                                                      roomPowerLevels: roomPowerLevels)
        if tappedUserIdText == matrixUseCase.getUserId() {
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
