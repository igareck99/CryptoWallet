import SwiftUI
import PhoneNumberKit

// MARK: - IPhoneNumberField(UIViewRepresentable)

public struct IPhoneNumberField: UIViewRepresentable {

    // MARK: - Internal Properties

    @Binding public var text: String
    @State private var displayedText: String
    private var externalIsFirstResponder: Binding<Bool>?
    @State private var internalIsFirstResponder = false
    private var isFirstResponder: Bool {
        get { externalIsFirstResponder?.wrappedValue ?? internalIsFirstResponder }
        set {
            if externalIsFirstResponder != nil {
                externalIsFirstResponder!.wrappedValue = newValue
            } else {
                internalIsFirstResponder = newValue
            }
        }
    }
    var maxDigits: Int?
    internal var font: UIFont?
    internal var clearButtonMode: UITextField.ViewMode = .never
    private let placeholder: String?
    internal var showFlag = false
    internal var selectableFlag = false
    internal var autofillPrefix = false
    internal var previewPrefix = false
    internal var defaultRegion: String?
    internal var textColor: UIColor?
    internal var accentColor: UIColor?
    internal var numberPlaceholderColor: UIColor?
    internal var countryCodePlaceholderColor: UIColor?
    internal var borderStyle: UITextField.BorderStyle = .none
    internal var formatted: Bool = true
    internal var onBeginEditingHandler = { (_: PhoneNumberTextField) in }
    internal var onEditingChangeHandler = { (_: PhoneNumberTextField) in }
    internal var onPhoneNumberChangeHandler = { (_: PhoneNumber?) in }
    internal var onEndEditingHandler = { (_: PhoneNumberTextField) in }
    internal var onClearHandler = { (_: PhoneNumberTextField) in }
    internal var onReturnHandler = { (_: PhoneNumberTextField) in }
    public var configuration = { (_: PhoneNumberTextField) in }
    @Environment(\.layoutDirection) internal var layoutDirection: LayoutDirection
    internal var textAlignment: NSTextAlignment?
    internal var clearsOnBeginEditing = false
    internal var clearsOnInsertion = false
    internal var isUserInteractionEnabled = true

    // MARK: - Lifecycle

    public init(_ title: String? = nil,
                text: Binding<String>,
                isEditing: Binding<Bool>? = nil,
                formatted: Bool = true,
                configuration: @escaping (UIViewType) -> Void = { _ in } ) {

        self.placeholder = title
        self.externalIsFirstResponder = isEditing
        self.formatted = formatted
        self._text = text
        self._displayedText = State(initialValue: text.wrappedValue)
        self.configuration = configuration
    }

    // MARK: - Public Methods

    public func makeUIView(context: UIViewRepresentableContext<Self>) -> PhoneNumberTextField {
        let uiView = UIViewType()
        uiView.setContentHuggingPriority(.defaultHigh, for: .vertical)
        uiView.addTarget(context.coordinator,
                         action: #selector(Coordinator.textViewDidChange),
                         for: .editingChanged)
        uiView.delegate = context.coordinator
        uiView.withExamplePlaceholder = placeholder == nil
        if let defaultRegion = defaultRegion {
            uiView.partialFormatter.defaultRegion = defaultRegion
        }
        return uiView
    }

    public func updateUIView(_ uiView: PhoneNumberTextField, context: UIViewRepresentableContext<Self>) {
        configuration(uiView)
        uiView.textContentType = .telephoneNumber
        uiView.text = displayedText
        uiView.font = font
        uiView.maxDigits = maxDigits
        uiView.clearButtonMode = clearButtonMode
        uiView.placeholder = placeholder
        uiView.borderStyle = borderStyle
        uiView.textColor = textColor
        uiView.withFlag = showFlag
        uiView.withDefaultPickerUI = selectableFlag
        uiView.withPrefix = previewPrefix
        if placeholder != nil {
            uiView.placeholder = placeholder
        } else {
            uiView.withExamplePlaceholder = autofillPrefix
        }
        if autofillPrefix { uiView.resignFirstResponder() }
        uiView.tintColor = accentColor
        if let defaultRegion = defaultRegion {
            uiView.partialFormatter.defaultRegion = defaultRegion
        }
        if let numberPlaceholderColor = numberPlaceholderColor {
            uiView.numberPlaceholderColor = numberPlaceholderColor
        }
        if let countryCodePlaceholderColor = countryCodePlaceholderColor {
            uiView.countryCodePlaceholderColor = countryCodePlaceholderColor
        }
        if let textAlignment = textAlignment {
            uiView.textAlignment = textAlignment
        }
        if isFirstResponder {
            uiView.becomeFirstResponder()
        } else {
            uiView.resignFirstResponder()
        }
    }

    public func makeCoordinator() -> Coordinator {
        Coordinator(
            text: $text,
            displayedText: $displayedText,
            isFirstResponder: externalIsFirstResponder ?? $internalIsFirstResponder,
            formatted: formatted,
            onBeginEditing: onBeginEditingHandler,
            onEditingChange: onEditingChangeHandler,
            onPhoneNumberChange: onPhoneNumberChangeHandler,
            onEndEditing: onEndEditingHandler,
            onClear: onClearHandler,
            onReturn: onReturnHandler)
    }

    // MARK: - Coordinator(UITextFieldDelegate)

    public class Coordinator: NSObject, UITextFieldDelegate {

        // MARK: - Internal Properties

        var text: Binding<String>
        var displayedText: Binding<String>
        var isFirstResponder: Binding<Bool>
        var formatted: Bool
        var onBeginEditing = { (_: PhoneNumberTextField) in }
        var onEditingChange = { (_: PhoneNumberTextField) in }
        var onPhoneNumberChange = { (_: PhoneNumber?) in }
        var onEndEditing = { (_: PhoneNumberTextField) in }
        var onClear = { (_: PhoneNumberTextField) in }
        var onReturn = { (_: PhoneNumberTextField) in }

        // MARK: - Lifecycle

        internal init(
            text: Binding<String>,
            displayedText: Binding<String>,
            isFirstResponder: Binding<Bool>,
            formatted: Bool,
            onBeginEditing: @escaping (PhoneNumberTextField) -> Void = { (_: PhoneNumberTextField) in },
            onEditingChange: @escaping (PhoneNumberTextField) -> Void = { (_: PhoneNumberTextField) in },
            onPhoneNumberChange: @escaping (PhoneNumber?) -> Void = { (_: PhoneNumber?) in },
            onEndEditing: @escaping (PhoneNumberTextField) -> Void = { (_: PhoneNumberTextField) in },
            onClear: @escaping (PhoneNumberTextField) -> Void = { (_: PhoneNumberTextField) in },
            onReturn: @escaping (PhoneNumberTextField) -> Void = { (_: PhoneNumberTextField) in } ) {
            self.text = text
            self.displayedText = displayedText
            self.isFirstResponder = isFirstResponder
            self.formatted = formatted
            self.onBeginEditing = onBeginEditing
            self.onEditingChange = onEditingChange
            self.onPhoneNumberChange = onPhoneNumberChange
            self.onEndEditing = onEndEditing
            self.onClear = onClear
            self.onReturn = onReturn
        }

        // MARK: - Actions

        @objc func textViewDidChange(_ textField: UITextField) {
            guard let textField = textField as? PhoneNumberTextField else {
                return assertionFailure("Undefined state")
            }
            if formatted {
                text.wrappedValue = textField.text ?? ""
            } else {
                if let number = textField.phoneNumber {
                    let country = String(number.countryCode)
                    let nationalNumber = String(number.nationalNumber)
                    text.wrappedValue = "+" + country + nationalNumber
                } else {
                    text.wrappedValue = ""
                }
            }
            displayedText.wrappedValue = textField.text ?? ""
            onEditingChange(textField)
            onPhoneNumberChange(textField.phoneNumber)
        }

        // MARK: - Public methods

        public func textFieldDidBeginEditing(_ textField: UITextField) {
            isFirstResponder.wrappedValue = true
            onBeginEditing(textField as! PhoneNumberTextField)
        }

        public func textFieldDidEndEditing(_ textField: UITextField) {
            isFirstResponder.wrappedValue = false
            onEndEditing(textField as! PhoneNumberTextField)
        }

        public func textFieldShouldClear(_ textField: UITextField) -> Bool {
            displayedText.wrappedValue = ""
            onClear(textField as! PhoneNumberTextField)
            return true
        }

        public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            onReturn(textField as! PhoneNumberTextField)
            return true
        }
    }
}
