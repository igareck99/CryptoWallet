import UIKit
import SwiftUI

// MARK: - CurrencyUITextField

final class CurrencyUITextField: UITextField {

    // MARK: - Private Properties

    @Binding private var value: Int
    private let formatter: NumberFormatter

    private var textValue: String {
        return text ?? ""
    }

    private var doubleValue: Double {
        return (decimal as NSDecimalNumber).doubleValue
    }

    private var decimal: Decimal {
        return textValue.decimal / pow(10, formatter.maximumFractionDigits)
    }

    private func currency(from decimal: Decimal) -> String {
        return formatter.string(for: decimal) ?? ""
    }

    // MARK: - Lifecycle

    init(formatter: NumberFormatter, value: Binding<Int>) {
        self.formatter = formatter
        self._value = value
        super.init(frame: .zero)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func willMove(toSuperview newSuperview: UIView?) {
        addTarget(self, action: #selector(editingChanged), for: .editingChanged)
        addTarget(self, action: #selector(resetSelection), for: .allTouchEvents)
        keyboardType = .numberPad
        textAlignment = .left
        sendActions(for: .editingChanged)
    }

    override func deleteBackward() {
        text = textValue.digits.dropLast().string
        sendActions(for: .editingChanged)
    }

    // MARK: - Private Methods

    private func setupViews() {
        tintColor = .clear
        font = .systemFont(ofSize: 40, weight: .regular)
    }

    @objc private func editingChanged() {
        text = currency(from: decimal)
        resetSelection()
        value = Int(doubleValue * 100)
    }

    @objc private func resetSelection() {
        selectedTextRange = textRange(from: endOfDocument, to: endOfDocument)
    }
}

// MARK: - StringProtocol

extension StringProtocol where Self: RangeReplaceableCollection {
    var digits: Self { filter (\.isWholeNumber) }
}

// MARK: - String

extension String {
    var decimal: Decimal { Decimal(string: digits) ?? 0 }
}

// MARK: - LosslessStringConvertible

extension LosslessStringConvertible {
    var string: String { .init(self) }
}

// MARK: - CurrencyTextField

struct CurrencyTextField: UIViewRepresentable {

    // MARK: - Internal Properties

    typealias UIViewType = CurrencyUITextField

    let numberFormatter: NumberFormatter
    let currencyField: CurrencyUITextField

    // MARK: - Lifecycle

    init(numberFormatter: NumberFormatter, value: Binding<Int>) {
        self.numberFormatter = numberFormatter
        currencyField = CurrencyUITextField(formatter: numberFormatter, value: value)
    }

    // MARK: - Internal Properties

    func makeUIView(context: Context) -> CurrencyUITextField {
        currencyField
    }

    func updateUIView(_ uiView: CurrencyUITextField, context: Context) { }
}
