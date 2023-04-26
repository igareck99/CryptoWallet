import Foundation

// MARK: - MXRoom

extension MXRoom {

    // MARK: - Internal Properties

    var isMuted: Bool {
        if let rule = overridePushRule {
            if rule.conditionIsEnabled(kind: .eventMatch, for: roomId) && rule.actionsContains(actionType: MXPushRuleActionTypeDontNotify) {
                return true
            }
            return false
        }
        return false
    }

    func getRoomRule(from rules: [Any]) -> MXPushRule? {
        guard let pushRules = rules as? [MXPushRule] else {
            return nil
        }
        return pushRules.first(where: { self.roomId == $0.ruleId })
    }

    var allRules: [Any] {
        return mxSession.notificationCenter.flatRules
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
