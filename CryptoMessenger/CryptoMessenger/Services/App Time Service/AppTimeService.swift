import Foundation

protocol AppTimeServiceProtocol {
    func diffSinceLastBackgroundEnter() -> TimeInterval
    func diffFrom(timeInterval: TimeInterval) -> TimeInterval
    func saveTimeStamp()
}

final class AppTimeService {

    private let keychainService: KeychainServiceProtocol

    init(keychainService: KeychainServiceProtocol) {
        self.keychainService = keychainService
    }

    func getTimeStampUTCZero() -> TimeInterval? {
        let formatter = ISO8601DateFormatter()
        formatter.timeZone = TimeZone(secondsFromGMT: .zero)
        let dateString = formatter.string(from: Date())
        let timeInterval = formatter.date(from: dateString)?.timeIntervalSince1970
        return timeInterval
    }
}

// MARK: - AppTimeServiceProtocol

extension AppTimeService: AppTimeServiceProtocol {
    func diffSinceLastBackgroundEnter() -> TimeInterval {
        guard
            let lastTimeInterval = keychainService.double(forKey: .gmtZeroTimeInterval),
            lastTimeInterval != .zero
        else {
            return .zero
        }
        let diffTimeInterval = diffFrom(timeInterval: lastTimeInterval)
        return diffTimeInterval
    }

    func diffFrom(timeInterval: TimeInterval) -> TimeInterval {
        let currenttimeInterval = getTimeStampUTCZero() ?? .zero
        let diffTimeInterval = currenttimeInterval - timeInterval
        return diffTimeInterval
    }

    func saveTimeStamp() {
        let timeInterval = getTimeStampUTCZero() ?? .zero
        keychainService.set(timeInterval, forKey: .gmtZeroTimeInterval)
    }
}
