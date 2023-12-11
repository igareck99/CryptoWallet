import UIKit

// MARK: - PushNotificationsServiceProtocol

protocol PushNotificationsServiceProtocol {

	var isRegisteredForRemoteNotifications: Bool { get }

	func registerForRemoteNotifications()

	func requestForRemoteNotificationsAuthorizationState(
		options: UNAuthorizationOptions,
		completion: @escaping (Bool) -> Void
	)

	func requestForRemoteNotificationsAuthorizationStatus(
		completion: @escaping (UNNotificationSettings) -> Void
	)
    
    func mute(room: AuraRoom, completion: @escaping (NotificationsActionState) -> Void)
    func allMessages(room: AuraRoom, completion: @escaping (NotificationsActionState) -> Void)
}

// MARK: - NotificationsActionState

enum NotificationsActionState {
    case isAlreadyMuted
    case isAlreadyEnable
    case muteOn
    case allMessagesOn
}

// MARK: - PushNotificationsService

final class PushNotificationsService: NSObject {

	private let notificationCenter: UNUserNotificationCenter
	private let application: UIApplication
    static let shared = PushNotificationsService()

	init(
		application: UIApplication = .shared,
		notificationCenter: UNUserNotificationCenter = .current()
	) {
		self.application = application
		self.notificationCenter = notificationCenter
	}
}

// MARK: - PushNotificationsService(PushNotificationsServiceProtocol)

extension PushNotificationsService: PushNotificationsServiceProtocol {

	func requestForRemoteNotificationsAuthorizationState(
		options: UNAuthorizationOptions,
		completion: @escaping (Bool) -> Void
	) {
		notificationCenter.requestAuthorization(options: options) { isAllowed, error in
			debugPrint("Permission granted: \(isAllowed)")
			debugPrint("Permission error: \(error.debugDescription)")
			completion(isAllowed)
		}
	}

	func requestForRemoteNotificationsAuthorizationStatus(
		completion: @escaping (UNNotificationSettings) -> Void
	) {
		notificationCenter.getNotificationSettings { settings in
			debugPrint("Notification settings: \(settings)")
			completion(settings)
		}
	}

	func registerForRemoteNotifications() {
		DispatchQueue.main.async { [weak self] in
			self?.application.registerForRemoteNotifications()
		}
	}

    func addPushRuleToMute(room: AuraRoom) {
        guard let roomId = room.room.roomId else {
            return
        }
        room.room.mxSession.notificationCenter.addOverrideRule(
            withId: roomId,
            conditions: [["kind": "event_match", "key": "room_id", "pattern": roomId]],
            notify: false,
            sound: false,
            highlight: false
        )
    }
    
    func addPushRuleToUnmuteMute(room: AuraRoom) {
        guard let roomId = room.room.roomId else {
            return
        }
        room.room.mxSession.notificationCenter.addOverrideRule(
            withId: roomId,
            conditions: [["kind": "event_match", "key": "room_id", "pattern": roomId]],
            notify: true,
            sound: true,
            highlight: true
        )
    }

    func allMessages(
        room: AuraRoom,
        completion: @escaping (NotificationsActionState) -> Void
    ) {
        if !room.room.isMuted {
            completion(NotificationsActionState.isAlreadyEnable)
            return
        }
        if let rule = room.room.overridePushRule, room.room.isMuted {
            removePushRule(room: room, rule: rule)
            addPushRuleToUnmuteMute(room: room)
            completion(.allMessagesOn)
            return
        }

        if let rule = room.room.roomPushRule {
            removePushRule(room: room, rule: rule)
            addPushRuleToUnmuteMute(room: room)
            completion(.allMessagesOn)
            return
        }
    }

    func removePushRule(room: AuraRoom, rule: MXPushRule) {
        room.room.mxSession.notificationCenter.removeRule(rule)
    }

    func enablePushRule(room: AuraRoom, rule: MXPushRule) {
        room.room.mxSession.notificationCenter.enableRule(rule, isEnabled: true)
    }

    func mute(room: AuraRoom, completion: @escaping (NotificationsActionState) -> Void) {
        guard !room.room.isMuted else {
            completion(.isAlreadyMuted)
            return
        }

        if let rule = room.room.roomPushRule {
            removePushRule(room: room, rule: rule)
            self.mute(room: room) { value in
                completion(value)
            }
        }
        guard let rule = room.room.overridePushRule else {
            addPushRuleToMute(room: room)
            completion(.muteOn)
            return
        }
        if rule.actionsContains(actionType: MXPushRuleActionTypeDontNotify) {
            enablePushRule(room: room, rule: rule)
            completion(.muteOn)
        } else {
            removePushRule(room: room, rule: rule)
            self.addPushRuleToMute(room: room)
            completion(.muteOn)
        }
    }

	var isRegisteredForRemoteNotifications: Bool {
		application.isRegisteredForRemoteNotifications
	}
}
