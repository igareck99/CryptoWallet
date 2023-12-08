import Foundation

enum MXEventEventKey: String {
    case messageType = "msgtype"
    case url
    case latitude
    case longitude
    case body
    case avatar
    case userId
    case name
    case phone
    case mxId
    case info
    case thumbnailUrl = "thumbnail_url"
    case thumbnailInfo = "thumbnail_info"
    case newContent = "m.new_content"
    case eventId = "event_id"
    case relatesTo = "m.relates_to"
    case inReplyTo = "m.in_reply_to"
    case customContent = "m.reply_to"
    case rootUserId = "root_user_id"
    case rootMessage = "root_message"
    case rootEventId = "root_event_id"
    case rootLink = "root_link"
    case amount
    case date
    case receiver
    case sender
    case hash
    case block
    case status
    case currency
}
