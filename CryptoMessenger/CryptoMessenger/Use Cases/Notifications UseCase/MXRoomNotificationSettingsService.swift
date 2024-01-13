import Foundation
import MatrixSDK

// MARK: - MXRoomNotificationSettingsService(RoomNotificationSettingsServiceType)

final class MXRoomNotificationSettingsService: RoomNotificationSettingsServiceType {
    typealias Completion = () -> Void

    private let roomId: String
    private let room: AuraRoomData?
    private var notificationCenterDidUpdateObserver: NSObjectProtocol?
    private var notificationCenterDidFailObserver: NSObjectProtocol?
    private var observers: [ObjectIdentifier] = []
    private let matrixUseCase: MatrixUseCaseProtocol
    private var notificationCenter: MXNotificationCenter? {
        room?.room.mxSession?.notificationCenter
    }
    private var globalNotificationCenter: MXNotificationCenter? {
        matrixUseCase.matrixSession?.notificationCenter
    }
    var notificationState: RoomNotificationState {
        room?.room.notificationState ?? .all
    }

    init(
        roomId: String,
        matrixUseCase: MatrixUseCaseProtocol = MatrixUseCase.shared
    ) {
        self.roomId = roomId
        self.matrixUseCase = matrixUseCase
        self.room = matrixUseCase.rooms.first(where: { $0.room.roomId == roomId })
    }

    deinit {
        observers.forEach(NotificationCenter.default.removeObserver)
    }

    // MARK: - Public

    func observeNotificationState(listener: @escaping RoomNotificationStateCallback) {
        guard let auraRoom = room else { return }
        let observer = NotificationCenter.default.addObserver(
            forName: NSNotification.Name(rawValue: kMXNotificationCenterDidUpdateRules),
            object: nil,
            queue: OperationQueue.main
        ) { [weak self] _ in
            guard let self = self else { return }
            listener(auraRoom.room.notificationState)
        }
        observers += [ObjectIdentifier(observer)]
    }

    func notificationsOnAllDevice(_ state: Bool) {
        let rule = globalNotificationCenter?.rule(byId: ".m.rule.master")
        globalNotificationCenter?.enableRule(rule, isEnabled: !state)
    }

    func getNotificationsOnAllDeviceState() -> Bool? {
        guard let rule = globalNotificationCenter?.rule(byId: ".m.rule.master") else {
            return nil
        }
        return !rule.enabled
    }

    func update(state: RoomNotificationState, completion: @escaping Completion) {
        switch state {
        case .all:
            allMessages(completion: completion)
        case .mentionsAndKeywordsOnly:
            mentionsOnly(completion: completion)
        case .mute:
            mute(completion: completion)
        }
    }

    // MARK: - Private

    private func mute(completion: @escaping Completion) {
        guard let auraRoom = room else { return }
        guard !auraRoom.room.isMuted else {
            completion()
            return
        }
        if let rule = auraRoom.room.roomPushRule {
            removePushRule(rule: rule) {
                self.mute(completion: completion)
            }
            return
        }
        guard let rule = auraRoom.room.overridePushRule else {
            addPushRuleToMute(completion: completion)
            return
        }

        guard notificationCenterDidUpdateObserver == nil else {
            MXLog.debug("[RoomNotificationSettingsService] Request in progress: ignore push rule update")
            completion()
            return
        }

        if rule.actionsContains(actionType: MXPushRuleActionTypeDontNotify) {
            enablePushRule(rule: rule, completion: completion)
        } else {
            removePushRule(rule: rule) {
                self.addPushRuleToMute(completion: completion)
            }
        }
    }

    private func mentionsOnly(completion: @escaping Completion) {
        guard let auraRoom = room else { return }
        guard !auraRoom.room.isMentionsOnly else {
            completion()
            return
        }

        if let rule = auraRoom.room.overridePushRule, auraRoom.room.isMuted {
            removePushRule(rule: rule) {
                self.mentionsOnly(completion: completion)
            }
            return
        }

        guard let rule = auraRoom.room.roomPushRule else {
            addPushRuleToMentionOnly(completion: completion)
            return
        }

        guard notificationCenterDidUpdateObserver == nil else {
            MXLog.debug("[MXRoom+Riot] Request in progress: ignore push rule update")
            completion()
            return
        }

        // if the user defined one, use it
        if rule.actionsContains(actionType: MXPushRuleActionTypeDontNotify) {
            enablePushRule(rule: rule, completion: completion)
        } else {
            removePushRule(rule: rule) {
                self.addPushRuleToMentionOnly(completion: completion)
            }
        }
    }

    private func allMessages(completion: @escaping Completion) {
        guard let auraRoom = room else { return }
        if !auraRoom.room.isMentionsOnly, !auraRoom.room.isMuted {
            completion()
            return
        }

        if let rule = auraRoom.room.overridePushRule, auraRoom.room.isMuted {
            removePushRule(rule: rule) {
                self.allMessages(completion: completion)
            }
            return
        }

        if let rule = auraRoom.room.roomPushRule, auraRoom.room.isMentionsOnly {
            removePushRule(rule: rule, completion: completion)
        }
    }

    private func addPushRuleToMentionOnly(completion: @escaping Completion) {
        guard let auraRoom = room else { return }
        handleUpdateCallback(completion) { [weak self] in
            guard let self = self else { return true }
            return auraRoom.room.roomPushRule != nil
        }
        handleFailureCallback(completion)

        notificationCenter?.addRoomRule(
            auraRoom.roomId,
            notify: false,
            sound: false,
            highlight: false
        )
    }

    private func addPushRuleToMute(completion: @escaping Completion) {
        guard let auraRoom = self.room else { return }
        handleUpdateCallback(completion) { [weak self] in
            guard let self = self else { return true }
            return auraRoom.room.overridePushRule != nil
        }
        handleFailureCallback(completion)

        notificationCenter?.addOverrideRule(
            withId: auraRoom.roomId,
            conditions: [["kind": "event_match", "key": "room_id", "pattern": roomId]],
            notify: false,
            sound: false,
            highlight: false
        )
    }

    private func removePushRule(rule: MXPushRule, completion: @escaping Completion) {
        handleUpdateCallback(completion) { [weak self] in
            guard let self = self else { return true }
            return self.notificationCenter?.rule(byId: rule.ruleId) == nil
        }
        handleFailureCallback(completion)
        notificationCenter?.removeRule(rule)
    }

    private func enablePushRule(rule: MXPushRule, completion: @escaping Completion) {
        handleUpdateCallback(completion) {
            true
        }
        handleFailureCallback(completion)
        notificationCenter?.enableRule(rule, isEnabled: true)
    }

    private func handleUpdateCallback(_ completion: @escaping Completion, releaseCheck: @escaping () -> Bool) {
        notificationCenterDidUpdateObserver = NotificationCenter.default.addObserver(
            forName: NSNotification.Name(rawValue: kMXNotificationCenterDidUpdateRules),
            object: nil,
            queue: OperationQueue.main
        ) { [weak self] _ in
            guard let self = self else { return }
            if releaseCheck() {
                self.removeObservers()
                completion()
            }
        }
    }

    private func handleFailureCallback(_ completion: @escaping Completion) {
        notificationCenterDidFailObserver = NotificationCenter.default.addObserver(
            forName: NSNotification.Name(rawValue: kMXNotificationCenterDidFailRulesUpdate),
            object: nil,
            queue: OperationQueue.main
        ) { [weak self] _ in
            guard let self = self else { return }
            self.removeObservers()
            completion()
        }
    }

    func removeObservers() {
        if let observer = notificationCenterDidUpdateObserver {
            NotificationCenter.default.removeObserver(observer)
            notificationCenterDidUpdateObserver = nil
        }

        if let observer = notificationCenterDidFailObserver {
            NotificationCenter.default.removeObserver(observer)
            notificationCenterDidFailObserver = nil
        }
    }
}
