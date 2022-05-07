import Foundation

struct MatrixNotification: Codable {
	let roomId: String
	let eventId: String

	enum CodingKeys: String, CodingKey {
		case roomId = "room_id"
		case eventId = "event_id"
	}
}
