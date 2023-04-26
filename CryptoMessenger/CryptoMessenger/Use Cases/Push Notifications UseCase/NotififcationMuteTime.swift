import Foundation

// MARK: - NotififcationMuteTime

enum NotififcationMuteTime: CaseIterable, Identifiable {
    
    case eightHours
    case oneWeak
    case oneYear
    case always
    
    var id: UUID { UUID() }
    var description: String {
        switch self {
        case .always:
            return "Выключить уведомления"
        case .oneWeak:
            return "Не беспокоить 1 неделю"
        case .oneYear:
            return "Не беспокоить 1 год"
        case .eightHours:
            return "Не беспокоить 8 часов"
        }
    }

    var date: Double {
        let currentTime = Date().timeIntervalSince1970
        switch self {
        case .eightHours:
            return currentTime + (8 * 60 * 60)
        case .oneWeak:
            return currentTime + (7 * 24 * 60 * 60)
        case .oneYear:
            return currentTime + (365 * 24 * 60 * 60)
        case .always:
            return 0
        }
    }
}
