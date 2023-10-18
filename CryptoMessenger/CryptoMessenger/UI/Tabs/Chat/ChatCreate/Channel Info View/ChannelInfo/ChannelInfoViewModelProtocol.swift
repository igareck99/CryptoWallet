import SwiftUI

// MARK: - ChannelInfoViewModelProtocol

protocol ChannelInfoViewModelProtocol: ObservableObject {
    
    var chatData: Binding<ChatData> { get set }

    var selectedImg: UIImage? { get set }
    
    var roomImageUrl: URL? { get }
    
    var resources: ChannelInfoResourcable.Type { get }
    
    var roomImage: Image? { get }
    
    var shouldShowDescription: Bool { get }
    
    var isAuthorized: Bool { get }
    
    var leaveChannelText: String { get }
    
    var isChannel: Bool { get }
    
    var showChannelChangeType: Bool { get set }
    
    var changeViewEdit: Bool { get set }

    var room: AuraRoomData { get }
    
    var roomDisplayName: String { get set }
    
    var isRoomPublicValue: Bool { get set }
    
    var shouldChange: Bool { get set }
    
    var channelTopic: String { get set }
    
    var showMakeRole: Bool { get set }
    
    var showMakeNewRole: Bool { get set }
    
    var showLeaveChannel: Bool { get set }

    var showUserSettings: Bool { get set }

    var showChangeRole: Bool { get set }

    var showDeleteChannel: Bool { get set }

    var tappedUserId: String { get set }

    var showUserProfile: Bool { get set }
    
    var showSelectOwner: Bool { get set }
    
    var searchText: String { get set }
    
    var showSelectCurrentUserRole: Bool { get set }

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
    
    func setData()
    
    func getChannelUsersFiltered() -> [ChannelParticipantsData]
    
    func onAssignAnotherOwners(users: [ChannelParticipantsData],
                               newRole: ChannelRole?,
                               completion: @escaping () -> Void)
    
    func showParticipantsView(_ viewModel: ChannelInfoViewModel,
                              _ showParticipants: Binding<Bool>)
    
    func dismissSheet()
    
    func selectPhoto(_ sourceType: UIImagePickerController.SourceType)
}
