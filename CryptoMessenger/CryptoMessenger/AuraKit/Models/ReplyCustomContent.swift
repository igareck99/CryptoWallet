import Foundation


// MARK: - ReplyCustomContent

struct ReplyCustomContent: Codable {

    // MARK: - Internal Properties

    var rootUserId: String = "root_user_id"
    var rootMessage: String = "root_message"
    var rootEventId: String = "root_event_id"
    var rootLink: String = "root_link"
    var content: [String: Any] {
            return ["root_user_id": rootUserId,
                    "root_message": rootMessage,
                    "root_event_id": rootEventId,
                    "root_link": rootLink]
        }
}
