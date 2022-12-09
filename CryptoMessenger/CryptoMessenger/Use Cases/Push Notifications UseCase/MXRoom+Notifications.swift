import Foundation

// MARK: - MXRoom

extension MXRoom {

    // MARK: - Internal Properties

    var isMuted: Bool {
        // Check whether an override rule has been defined with the roomm id as rule id.
        // This kind of rule is created to mute the room
        guard let rule = overridePushRule,
              rule.actionsContains(actionType: MXPushRuleActionTypeDontNotify),
              rule.conditionIsEnabled(kind: .eventMatch, for: roomId) else {
            return false
        }
        return rule.enabled
    }

    func getRoomRule(from rules: [Any]) -> MXPushRule? {
        guard let pushRules = rules as? [MXPushRule] else {
            return nil
        }
        return pushRules.first(where: { self.roomId == $0.ruleId })
    }

    var overridePushRule: MXPushRule? {
        guard let overrideRules = mxSession.notificationCenter.rules.global.override else {
            return nil
        }
        return getRoomRule(from: overrideRules)
    }

    var roomPushRule: MXPushRule? {
        guard let roomRules = mxSession.notificationCenter.rules.global.room else {
            return nil
        }
        return getRoomRule(from: roomRules)
    }

    var isMentionsOnly: Bool {
        guard let rule = roomPushRule else { return false }
        return rule.enabled && rule.actionsContains(actionType: MXPushRuleActionTypeDontNotify)
    }

    var notificationState: RoomNotificationState {
        if isMuted {
            return .mute
        }
        if isMentionsOnly {
            return .mentionsAndKeywordsOnly
        }
        return .all
    }
}
