import Foundation

// MARK: - Date ()

extension Date {

    // MARK: - Internal Properties

    var dayAndMonth: String { Formatter.dayAndMonthFormatter.string(from: self) }
    var dayAndMonthAndYear: String { Formatter.dayFormatter.string(from: self) }
    var iso8601: String { Formatter.iso8601.string(from: self) }
    var is24HoursHavePassed: Bool { (Date().timeIntervalSince(self) / 3600) > 24 }
    var hoursAndMinutes: String { Formatter.timeFormatter.string(from: self) }
}

// MARK: - ISO8601DateFormatter ()

extension ISO8601DateFormatter {

    // MARK: - Lifecycle

    convenience init(_ formatOptions: Options, timeZone: TimeZone = TimeZone(secondsFromGMT: 0)!) {
        self.init()
        self.formatOptions = formatOptions
        self.timeZone = timeZone
    }
}

// MARK: - Formatter ()

extension Formatter {

    // MARK: - Static Properties

    static let iso8601 = ISO8601DateFormatter([.withInternetDateTime, .withTimeZone])

    static var dayAndMonthFormatter: DateFormatter {
        let df = DateFormatter()
        df.locale = .current
        df.dateFormat = "dd MMM"
        df.timeZone = .current
        return df
    }

    static var monthFormatter: DateFormatter {
        let df = DateFormatter()
        df.locale = .current
        df.dateFormat = "LLLL"
        df.timeZone = .current
        return df
    }

    static var timeFormatter: DateFormatter {
        let df = DateFormatter()
        df.locale = .current
        df.dateFormat = "HH:mm"
        df.timeZone = .current
        return df
    }

    static var dayFormatter: DateFormatter {
        let df = DateFormatter()
        df.locale = .current
        df.dateFormat = "dd.MM.yyyy"
        df.timeZone = .current
        return df
    }
}

// MARK: - String ()

extension String {

    // MARK: - Internal Properties

    var dateFromISO8601: Date? { Formatter.iso8601.date(from: self) }
}