import UIKit

// MARK: - NumberFormatterProtocol

protocol NumberFormatterProtocol: AnyObject {

    // MARK: - Internal Properties

    var numberStyle: NumberFormatter.Style { get set }
    var maximumFractionDigits: Int { get set }

    // MARK: - Internal Methods

    func string(from number: NSNumber) -> String?
    func string(for obj: Any?) -> String?
}

// MARK: - NumberFormatter (NumberFormatterProtocol)

extension NumberFormatter: NumberFormatterProtocol { }

// MARK: - PreviewNumberFormatter (NumberFormatterProtocol)

class PreviewNumberFormatter: NumberFormatterProtocol {

    // MARK: - Internal Properties

    let numberFormatter: NumberFormatter

    var numberStyle: NumberFormatter.Style {
        get {
            numberFormatter.numberStyle
        }
        set {
            numberFormatter.numberStyle = newValue
        }
    }
    
    var maximumFractionDigits: Int {
        get {
            return numberFormatter.maximumFractionDigits
        }
        set {
            numberFormatter.maximumFractionDigits = newValue
        }
    }

    // MARK: - Lifecycle

    init(locale: Locale) {
        numberFormatter = NumberFormatter()
        numberFormatter.locale = locale
    }

    // MARK: - Internal Methods

    func string(from number: NSNumber) -> String? {
        return numberFormatter.string(from: number)
    }

    func string(for obj: Any?) -> String? {
        numberFormatter.string(for: obj)
    }
}
