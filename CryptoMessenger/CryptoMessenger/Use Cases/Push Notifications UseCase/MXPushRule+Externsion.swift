import Foundation
import MatrixSDK

// MARK: - MXPushRule

public extension MXPushRule {
    func actionsContains(actionType: MXPushRuleActionType) -> Bool {
        guard let actions = actions as? [MXPushRuleAction] else {
            return false
        }
        return actions.contains(where: { $0.actionType == actionType })
    }

    func conditionIsEnabled(kind: MXPushRuleConditionType, for roomId: String) -> Bool {
        guard let conditions = conditions as? [MXPushRuleCondition] else {
            return false
        }
        let ruleContainsCondition = conditions.contains { condition in
            guard case kind = MXPushRuleConditionType(identifier: condition.kind),
                  let key = condition.parameters["key"] as? String,
                  let pattern = condition.parameters["pattern"] as? String
            else { return false }
            return key == "room_id" && pattern == roomId
        }
        return ruleContainsCondition && enabled
    }
}
