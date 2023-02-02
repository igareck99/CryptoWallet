import Foundation

protocol ChannelUsersFactoryProtocol {

    static func makeUserData(user: MXRoomMember) -> ChannelParticipantsData

    static func makeUsersData(users: [MXRoomMember]) -> [ChannelParticipantsData]
}

enum ChannelUsersFactory: ChannelUsersFactoryProtocol {
    static func makeUserData(user: MXRoomMember) -> ChannelParticipantsData {
        ChannelParticipantsData(name: user.displayname, matrixId: user.userId, role: .user)
    }

    static func makeUsersData(users: [MXRoomMember]) -> [ChannelParticipantsData] {
        users.compactMap {
            debugPrint("membership: \($0.membership)")
            guard $0.membership == .join else { return nil }
            return ChannelParticipantsData(
                name: $0.displayname,
                matrixId: $0.userId,
                role: .user,
                avatar: URL(string: $0.avatarUrl),
                status: "",
                phone: "",
                isAdmin: false
            )
        }
    }
}
