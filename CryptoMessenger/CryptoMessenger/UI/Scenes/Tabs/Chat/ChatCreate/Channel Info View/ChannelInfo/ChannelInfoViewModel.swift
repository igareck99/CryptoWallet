import SwiftUI

// swiftlint: disable: all

// MARK: - ChannelInfoViewModelProtocol

protocol ChannelInfoViewModelProtocol: ObservableObject {
    
    var shouldShowDescription: Bool { get }
    
    var isAuthorized: Bool { get }

    var roomId: String { get }
    
    var isRoomPublicValue: Bool { get set }
    
    var shouldChange: Bool { get set }
    
    var channelTopic: Binding<String> { get set }
   
    var channelName: Binding<String> { get set }
    
    var channelTopicText: String { get set }
   
    var channelNameText: String { get set }
    
    var showMakeRole: Binding<Bool> { get set }
    
    var showLeaveChannel: Binding<Bool> { get set }

    var showUserSettings: Binding<Bool> { get set }

    var showChangeRole: Binding<Bool> { get set }

    var showDeleteChannel: Binding<Bool> { get set }

    var tappedUserId: Binding<String> { get set }

    var showUserProfile: Binding<Bool> { get set }
    
    var showSelectOwner: Binding<Bool> { get set }

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

    func onRoleSelected(role: ChannelRole)

    func onDeleteAllUsers()

    func onDeleteChannel()

    func onShowUserProfile()
    
    func onLeaveChannel()
    
    func nextScene(_ scene: ChannelInfoFlow.Event)
    
    func onMakeRoleTap()
    
    func getCurrentUserRole() -> ChannelRole
    
    func getUserRole(_ userId: String) -> ChannelRole
    
    func compareRoles() -> Bool
    
    func isRoomPublic()
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
    
    lazy var showSelectOwner: Binding<Bool> = .init(
        get: {
            self.showSelectOwnerState
        },
        set: { newValue in
            self.showSelectOwnerState = newValue
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
    
    let roomId: String
    weak var delegate: ChannelInfoSceneDelegate?
    private let onInviteUsersToChannelGroup = DispatchGroup()
    private let matrixUseCase: MatrixUseCaseProtocol
    private let factory: ChannelUsersFactoryProtocol.Type
    private var roomPowerLevels: MXRoomPowerLevels?
    private var eventsListener: MXEventListener?

    init(
        roomId: String,
        matrixUseCase: MatrixUseCaseProtocol = MatrixUseCase.shared,
        factory: ChannelUsersFactoryProtocol.Type = ChannelUsersFactory.self
    ) {
        self.roomId = roomId
        self.matrixUseCase = matrixUseCase
        self.factory = factory
        self.getRoomInfo()
        self.loadUsers()
        self.isRoomPublic()
        self.listenEvents()
    }
    
    private func updateRoomParams() {
        
        guard shouldChange else { return }
        
        shouldChange = false
        
        matrixUseCase.setRoom(topic: channelTopicText, roomId: roomId) { result in
            debugPrint("matrixUseCase.setRoom.topic result: \(result)")
        }
        
        matrixUseCase.setRoom(name: channelNameText, roomId: roomId) { result in
            debugPrint("matrixUseCase.setRoom.name result: \(result)")
        }
    }
    
    private func getRoomInfo() {
        if let room = matrixUseCase.getRoomInfo(roomId: roomId) {
            channelNameText = room.summary.displayname
            channelTopicText = room.summary.topic
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
                
                if event.type == "m.room.topic",
                   let topic = room?.summary.topic {
                    self?.channelTopicText = topic
                    self?.objectWillChange.send()
                    return
                }
                
                if event.type == "m.room.name",
                   let displayname = room?.summary.displayname {
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
    
    func onMakeRoleTap() {
        self.showSelectOwner.wrappedValue = true
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
                   self.onLeaveRoom()
                   return
               }

               let ownersList = state.members.members
                   .filter { state.powerLevels.powerLevelOfUser(withUserID: $0.userId) == 100 }
               
               let isOnlyOneOwner = ownersList.count == 1

               // Если текущий пользователь не является единственным владельцем канала (такое может быть?)
               if !isOnlyOneOwner {
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
            self.delegate?.handleNextScene(.channelMedia(auraRoom))
        default:
            break
        }
    }

    func onShowUserProfile() {
        guard let user = participants.first(where: { $0.matrixId == tappedUserIdText }) else { return }
        let contact = Contact(mxId: user.matrixId, avatar: user.avatar, name: user.name, status: user.status)
        delegate?.handleNextScene(.friendProfile(contact))
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
            ) { [weak self] in
                debugPrint("matrixUseCase.kickUser result: \($0)")
                // TODO: Обработать failure case
                guard case .success = $0 else { return }
            }
        }
    }
    
    func onRoleSelected(role: ChannelRole) {
        guard let matrixId = UserIdValidator.makeValidId(userId: tappedUserIdText) else { return }
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
    
    func onInviteUsersToChannel(users: [Contact]) {
        
        for user in users {
            debugPrint("onInviteUsersToChannelGroup leave")
            onInviteUsersToChannelGroup.enter()
            matrixUseCase.inviteUser(userId: user.mxId, roomId: roomId) { [weak self] result in
                
                debugPrint("inviteUser result: \(result)")
                
                // TODO: Обработать failure case
               
                guard let self = self, case .success = result else { return }
                
                self.matrixUseCase.updateUserPowerLevel(userId: user.mxId, roomId: self.roomId, powerLevel: 0) { [weak self] result in
                    debugPrint("inviteUser result: \(result)")
                    debugPrint("onInviteUsersToChannelGroup leave")
                    self?.onInviteUsersToChannelGroup.leave()
                }
            }
        }
        onInviteUsersToChannelGroup.notify(queue: .main) {
            debugPrint("onInviteUsersToChannelGroup notify")
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
            ) { [weak self] result in
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
        matrixUseCase.leaveRoom(roomId: roomId) { [weak self] result in
            self?.loadUsers()
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
    
    func compareRoles() -> Bool {
        let selectedUserRole = factory.detectUserRole(userId: self.tappedUserIdText,
                                                      roomPowerLevels: roomPowerLevels)
        let currentUserRole = factory.detectUserRole(userId: matrixUseCase.getUserId(),
                                                      roomPowerLevels: roomPowerLevels)
        if selectedUserRole == .owner && currentUserRole == .owner {
            return false
        }
        return currentUserRole.powerLevel > selectedUserRole.powerLevel
    }
}
