import SwiftUI

// MARK: - NumberFormatterProtocol

class MyStingyDouble {

    // MARK: - Internal Properties

    var value: Double
    var string: String {
        didSet {
            if let tmp = Double(string) {
                value = tmp
            }
        }
    }
    var format: String
    var name: String

    // MARK: - Lifecycle

    init(name: String, value: Double, format: String) {
        self.string = String(format: format, value)
        self.value = value
        self.name = name
        self.format = format
    }

    // MARK: - Internal Properties

    func set(value: Double) {
        self.value = value
        self.string = String(format: self.format, value)
    }
}

// MARK: - NumberFormatter

extension NumberFormatter {
    static var decimal: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 3
        formatter.numberStyle = .decimal
        return formatter
    }
}

// MARK: - ZeroNumber

class ZeroNumber: ObservableObject {

    // MARK: - Internal Properties

    @Published var myFirstDouble = "0"
    var firstDouble: Double {
        get {
            if let tmp = Double(myFirstDouble) {
                return tmp
            }
            return 0
        }
        set(newValue) {
            myFirstDouble = String(format: "%0.4f", firstDouble)
        }
    }
}
