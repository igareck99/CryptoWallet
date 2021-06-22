import Firebase
import FirebaseMessaging
import UserNotifications

// MARK: - PushNotificationsManager

final class PushNotificationsManager: NSObject {

    // MARK: - Internal Properties

    static let shared = PushNotificationsManager()

    var deviceToken: String?

    var fcmToken: String {
        let token = Messaging.messaging().fcmToken
        return token ?? ""
    }

    var isRegisteredForRemoteNotifications: Bool { UIApplication.shared.isRegisteredForRemoteNotifications }

    var didAllowPushNotification: VoidBlock?
    var didTabOnNotification: (([String: Any]) -> Void)?
    var didSwipeOnNotification: (([String: Any]) -> Void)?
    var didTabOnShowMoreButtonNotification: (([String: Any]) -> Void)?

    // MARK: - Lifecycle

    override private init() {
        super.init()

        UNUserNotificationCenter.current().delegate = self
        Messaging.messaging().delegate = self
    }

    // MARK: - Internal Methods

    func setUpDeviceToken(deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
        self.deviceToken = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
    }

    func registerForPushNotifications() {
        Messaging.messaging().isAutoInitEnabled = true

        if !isRegisteredForRemoteNotifications {
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: { granted, _ in
                    if granted {
                        self.didAllowPushNotification?()
                    }
                })
            UIApplication.shared.registerForRemoteNotifications()
        }

        updatePushTokenIfNeeded()
    }

    func unregisterForPushNotifications() {
        UIApplication.shared.unregisterForRemoteNotifications()
    }

    func updatePushTokenIfNeeded() {
        if let token = Messaging.messaging().fcmToken {
            print("FCM token 🥳🥳🥳🥳🥳🥳🥳🥳🥳🥳🥳🥳🥳🥳🥳🥳: \(token)")
        }
    }

    func getFCMToken(complete: @escaping (String) -> Void) {
        if let token = Messaging.messaging().fcmToken {
            complete(token)
        }
    }

    func extractUserInfo(_ userInfo: [AnyHashable: Any]) -> (title: String, body: String) {
        var info = (title: "", body: "")
        guard let aps = userInfo["aps"] as? [String: Any] else {
            return info
        }
        guard let alert = aps["alert"] as? [String: Any] else {
            return info
        }
        let title = alert["title"] as? String ?? ""
        let body = alert["body"] as? String ?? ""
        info = (title: title, body: body)
        return info
    }

    func handlePushNotification(_ application: UIApplication, userInfo: [AnyHashable: Any]) {
        guard application.applicationState == .active else { return }
    }

    func fireLocalPush(_ userInfo: [AnyHashable: Any]) {
        let content = UNMutableNotificationContent()
        let alert = self.extractUserInfo(userInfo)
        let identifier = userInfo["google.c.a.c_l"] as? String ?? "No Category Identifier founded"
        content.categoryIdentifier = identifier
        content.title = alert.title
        content.body = alert.body
        content.userInfo = userInfo
        content.sound = .default

        let trigger = UNCalendarNotificationTrigger(dateMatching: .init(), repeats: false)
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { error in
            print(error?.localizedDescription ?? "")
        }
    }

    func resetBadge() {
        UIApplication.shared.applicationIconBadgeNumber = 0
    }

}

// MARK: - PushNotificationsManager (MessagingDelegate)

extension PushNotificationsManager: MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        let dataDict: [String: String] = ["token": fcmToken ?? ""]
        NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
    }
}

// MARK: - PushNotificationsManager (UNUserNotificationCenterDelegate)

extension PushNotificationsManager: UNUserNotificationCenterDelegate {
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        completionHandler()
    }

    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler
            completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        if #available(iOS 14.0, *) {
            completionHandler([.list, .badge, .sound])
        } else {
            completionHandler([.alert, .badge, .sound])
        }
    }
}
