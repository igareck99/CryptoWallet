import Foundation

// swiftlint: disable: all

protocol ChannelUsersFactoryProtocol {

    static func makeUserData(user: MXRoomMember) -> ChannelParticipantsData

    static func makeUsersData(
        users: [MXRoomMember],
        roomPowerLevels: MXRoomPowerLevels?
    ) -> [ChannelParticipantsData]
}

enum ChannelUsersFactory: ChannelUsersFactoryProtocol {
    static func makeUserData(user: MXRoomMember) -> ChannelParticipantsData {
        ChannelParticipantsData(name: user.displayname, matrixId: user.userId, role: .user)
    }

    static func makeUsersData(
        users: [MXRoomMember],
        roomPowerLevels: MXRoomPowerLevels?
    ) -> [ChannelParticipantsData] {
        users.compactMap {
            debugPrint("membership: \($0.membership)")
            guard $0.membership == .join else { return nil }
            return ChannelParticipantsData(
                name: $0.displayname,
                matrixId: $0.userId,
                role: detectUserRole(userId: $0.userId, roomPowerLevels: roomPowerLevels),
                avatar: URL(string: $0.avatarUrl),
                status: "",
                phone: "",
                isAdmin: false
            )
        }
    }
    
    static func detectUserRole(
        userId: String,
        roomPowerLevels: MXRoomPowerLevels?
    ) -> ChannelRole {
        
        guard let userPowerLevel: Int = roomPowerLevels?.powerLevelOfUser(withUserID: userId) else { return .unknown }
        
        if userPowerLevel == ChannelRole.owner.powerLevel {
            return .owner
        }
        
        if userPowerLevel == ChannelRole.admin.powerLevel {
            return .admin
        }
        
        return .user
    }
}
