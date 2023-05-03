import Foundation
import MatrixSDK

protocol MatrixObjectFactoryProtocol {

	func makeRooms(
		mxRooms: [MXRoom]?,
		isRoomUserActive: @escaping (String) -> Bool
	) -> [AuraRoom]
}

struct MatrixObjectFactory {}

// MARK: - MatrixObjectFactoryProtocol

extension MatrixObjectFactory: MatrixObjectFactoryProtocol {

	func makeRooms(
		mxRooms: [MXRoom]?,
		isRoomUserActive: @escaping (String) -> Bool
	) -> [AuraRoom] {
		guard let matrixRooms = mxRooms else { return [] }
		let auraRooms: [AuraRoom] = matrixRooms
			.map { mxRoom in
				let room = AuraRoom(mxRoom)
				if mxRoom.isDirect {
					room.isOnline = isRoomUserActive(mxRoom.directUserId)
				}
				return room
			}
			.compactMap { $0 }
			.sorted { $0.summary.lastMessageDate > $1.summary.lastMessageDate }
		return auraRooms
	}
}
