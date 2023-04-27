import UserNotifications

class NotificationService: UNNotificationServiceExtension {

    var contentHandler: ((UNNotificationContent) -> Void)?
    var bestAttemptContent: UNMutableNotificationContent?

    override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
        let userInfo = request.content.userInfo
        self.contentHandler = contentHandler
        guard let roomId = userInfo["room_id"] as? String,
              let eventId = userInfo["event_id"] as? String else {
            //  it's not a Matrix notification, do not change the content
            contentHandler(request.content)
            return
        }
        guard let content = request.content.mutableCopy() as? UNMutableNotificationContent else {
            return
        }
        content.badge = userInfo["unread_count"] as? NSNumber
        content.title = roomId
        content.body = eventId
        contentHandler(content)
//        if let bestAttemptContent = bestAttemptContent {
//            // Modify the notification content here...
//            bestAttemptContent.title = "\(bestAttemptContent.title) [modified]"
//            bestAttemptContent.body = "Пидорское body"
//
//            contentHandler(bestAttemptContent)
//        }
    }
    
    override func serviceExtensionTimeWillExpire() {
        // Called just before the extension will be terminated by the system.
        // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
        if let contentHandler = contentHandler, let bestAttemptContent = bestAttemptContent {
            contentHandler(bestAttemptContent)
        }
    }

}
