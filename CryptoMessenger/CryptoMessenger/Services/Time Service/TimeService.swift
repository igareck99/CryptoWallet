import Foundation

protocol TimeServiceProtocol {
	static func getTimeStampUTCZero() -> TimeInterval?
}

struct TimeService { }

// MARK: - TimeServiceProtocol

extension TimeService: TimeServiceProtocol {
	static func getTimeStampUTCZero() -> TimeInterval? {
		let formatter = ISO8601DateFormatter()
		formatter.timeZone = TimeZone(secondsFromGMT: .zero)
		let dateString = formatter.string(from: Date())
		let timeInterval = formatter.date(from: dateString)?.timeIntervalSince1970
		return timeInterval
	}
}
