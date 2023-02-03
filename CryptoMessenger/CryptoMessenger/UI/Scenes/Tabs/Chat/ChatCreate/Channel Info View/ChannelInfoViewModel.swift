import SwiftUI

// swiftlint: disable: all

// MARK: - ChannelInfoViewModelProtocol

protocol ChannelInfoViewModelProtocol: ObservableObject {

    var roomId: String { get }
    
    var shouldChange: Bool { get set }
    
    var channelTopic: Binding<String> { get set }
   
    var channelName: Binding<String> { get set }
    
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
    
    func onAssignNewOwners(users:  [Contact])

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
}

// MARK: - ChannelInfoViewModel

final class ChannelInfoViewModel {

    private var tappedUserIdText = ""

    lazy var tappedUserId: Binding<String> = .init(
        get: {
            self.tappedUserIdText
        },
        set: { newValue in
            self.tappedUserIdText = newValue
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
    
    private var channelTopicText: String = "" {
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

    var isSnackbarPresented = false

    private var participants = [ChannelParticipantsData]() {
        didSet {
            self.objectWillChange.send()
        }
    }
    private let matrixUseCase: MatrixUseCaseProtocol
    private let factory: ChannelUsersFactoryProtocol.Type
    let roomId: String

    weak var delegate: ChannelInfoSceneDelegate?
    private var roomPowerLevels: MXRoomPowerLevels?

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
    }
    
    private func updateRoomParams() {
        
        guard shouldChange else { return }
        
        shouldChange = false
        
        matrixUseCase.setRoom(topic: channelTopicText, roomId: roomId) { [weak self] result in
            
            debugPrint("matrixUseCase.setRoom.topic result: \(result)")
            
            guard case .success = result else { return }
            
            DispatchQueue.main.async { [weak self] in
                self?.getRoomInfo()
            }
        }
        
        matrixUseCase.setRoom(name: channelNameText, roomId: roomId) { [weak self] result in
            
            debugPrint("matrixUseCase.setRoom.name result: \(result)")
            
            guard case .success = result else { return }
            
            DispatchQueue.main.async { [weak self] in
                self?.getRoomInfo()
            }
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
            debugPrint("roomState power levels result: \(state.powerLevels)")
            
            self.roomPowerLevels = state.powerLevels
        }
    }
    
    private func loadUsers() {
        matrixUseCase.getRoomMembers(roomId: roomId) { [weak self] result in
            debugPrint("getRoomMembers result: \(result)")
            guard case let .success(roomMembers) = result else { return }
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                let users: [ChannelParticipantsData] = self.factory.makeUsersData(users: roomMembers.members, roomPowerLevels: self.roomPowerLevels)
                self.participants = users
            }
        }
    }

    private func showProfile() {
        showUserSettingsState = false
        DispatchQueue.main.async {
            self.onShowUserProfile()
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
               debugPrint("roomState power levels result: \(state.powerLevels)")

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
                guard case .success = $0 else { return }
            }
        }
    }
    
    func onRoleSelected(role: ChannelRole) {
        guard let matrixId = UserIdValidator.makeValidId(userId: tappedUserIdText) else { return }
        debugPrint("\(matrixId)")
        matrixUseCase.updateUserPowerLevel(
            userId: tappedUserIdText,
            roomId: roomId,
            powerLevel: role.powerLevel
        ) { [weak self] result in
            debugPrint("onTapChangeRole")
            debugPrint("room.setPowerLevel result: \(result)")
            debugPrint("onTapChangeRole")
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
    
    func onAssignNewOwners(users:  [Contact]) {
        
        users.forEach {
            guard let matrixId = UserIdValidator.makeValidId(userId: $0.mxId) else { return }
            debugPrint("\(matrixId)")
            matrixUseCase.updateUserPowerLevel(
                userId: matrixId,
                roomId: roomId,
                powerLevel: ChannelRole.owner.powerLevel
            ) { [weak self] result in
                debugPrint("onTapChangeRole")
                debugPrint("room.setPowerLevel result: \(result)")
                debugPrint("onTapChangeRole")
                
                self?.onLeaveRoom()
            }
        }
    }

    func onInviteUsersToChannel(users: [Contact]) {
        guard let auraRoom = matrixUseCase.rooms.first(where: { $0.room.roomId == roomId }) else { return }
        for user in users {
            matrixUseCase.inviteUser(userId: user.mxId,
                                     roomId: roomId) { result in
                debugPrint(result)
            }
            auraRoom.room.setPowerLevel(ofUser: user.mxId,
                                        powerLevel: 0) { response in
                debugPrint(response)
            }
        }
        // Удалить потом
        loadUsers()
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
            debugPrint("onDeleteUserFromChannel: \(result)")
            self?.loadUsers()
        }
    }

    func getChannelUsers() -> [ChannelParticipantsData] {
        participants
    }
    
    func updateUserRole(mxId: String, userRole: ChannelRole) {
        debugPrint("Rolw of \(mxId)  is updated to \(userRole)")
    }
}
