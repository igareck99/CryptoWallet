import SwiftUI

// MARK: - ChannelInfoViewModelProtocol

protocol ChannelInfoViewModelProtocol: ObservableObject {

    var roomId: String { get }

    var showUserSettings: Binding<Bool> { get set }

    var showChangeRole: Binding<Bool> { get set }

    var showDeleteChannel: Binding<Bool> { get set }

    var tappedUserId: Binding<String> { get set }

    var showUserProfile: Binding<Bool> { get set }

    var isSnackbarPresented: Bool { get set }

    func onChannelLinkCopy()

    func onDeleteUserFromChannel()

    func onInviteUserToChannel()

    func onInviteUsersToChannel(users: [Contact])

    func onBanUserFromChannel()

    func onUnbanUserFromChannel()

    func getChannelUsers() -> [ChannelParticipantsData]

    func updateUserRole(mxId: String, userRole: ChannelRole)

    func onUserRemoved()

    func onRoleSelected(role: ChannelRole)

    func onDeleteAllUsers()

    func onDeleteChannel()

    func onShowUserProfile()
    
    func nextScene(_ scene: ChannelInfoFlow.Event)
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

    init(
        roomId: String,
        matrixUseCase: MatrixUseCaseProtocol = MatrixUseCase.shared,
        factory: ChannelUsersFactoryProtocol.Type = ChannelUsersFactory.self
    ) {
        self.roomId = roomId
        self.matrixUseCase = matrixUseCase
        self.factory = factory
        self.loadUsers()
    }
    
    private func loadUsers() {
        matrixUseCase.getRoomMembers(roomId: roomId) { [weak self] result in
            debugPrint("getRoomMembers result: \(result)")
            guard case let .success(roomMembers) = result else { return }
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                let users: [ChannelParticipantsData] = self.factory.makeUsersData(users: roomMembers.members)
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
        participants.forEach {
            guard let matrixId = UserIdValidator.makeValidId(userId: $0.matrixId) else { return }
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
//        users.forEach { [weak self] user in
//            guard let useSelf = self else { return }
//            useSelf.matrixUseCase.inviteUser(
//                userId: user.mxId,
//                roomId: useSelf.roomId
//            ) { [weak self] result in
//                debugPrint("inviteUser to channel result: \(result)")
//                guard case .success = result else { return }
//                guard let inviteSelf = self else { return}
//                inviteSelf.matrixUseCase
//                    .updateUserPowerLevel(
//                        userId: user.mxId,
//                        roomId: inviteSelf.roomId,
//                        powerLevel: 0) { [weak self] result in
//                            // TODO: Hanlde failure case
//                            debugPrint("updateUserPowerLevel result: \(result)")
//                            guard let powerLevelSelf = self else { return }
//                            powerLevelSelf.loadUsers()
//                        }
//            }
//        }
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
        matrixUseCase.leaveRoom(roomId: "") { result in
            debugPrint("onDeleteUserFromChannel: \(result)")
        }
    }

    func getChannelUsers() -> [ChannelParticipantsData] {
        participants
    }
    
    func updateUserRole(mxId: String, userRole: ChannelRole) {
        debugPrint("Rolw of \(mxId)  is updated to \(userRole)")
    }
}
