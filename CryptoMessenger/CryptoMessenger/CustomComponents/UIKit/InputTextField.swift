import UIKit

// MARK: InputTextFieldSettings

struct InputTextFieldSettings {

    // MARK: - Public Properties

    var startBackground: UIColor? = .lightGray
    var fillBackground: UIColor? = .lightGray
    var topTitleText: String?
    var bottomTitleText: String?
    var topTitleColor: UIColor? = UIColor.black.withAlphaComponent(0.4)
    var bottomTitleColor: UIColor? = .red
    var titleFont: UIFont = .systemFont(ofSize: 18)
    var placeholderText: String?
    lazy var placeholderAttributes: [NSAttributedString.Key: Any]? = {
        [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16),
            NSAttributedString.Key.foregroundColor: UIColor.black.withAlphaComponent(0.4)
        ]
    }()

    var startBorderColor: UIColor? = .lightGray
    var fillBorderColor: UIColor? = .lightGray
    var startBorderWidth = CGFloat(1)
    var fillBorderWidth = CGFloat(1)

    var radius = CGFloat(8.0)

    var clearButtonImage: UIImage?
    var clearButtonImageColor: UIColor? = .clear

    var leftPadding = CGFloat(16.0)
    var rightPadding = CGFloat(16.0)
}

// MARK: - InputTextView

final class InputTextView: UIView {

    // MARK: - Public Properties

    var onTextChanged: StringBlock?
    var onTextBeginEditing: StringBlock?
    var text: String { textField.text ?? "" }
    var keyboardType: UIKeyboardType = .default {
        didSet {
            textField.keyboardType = keyboardType
        }
    }

    // MARK: - Private Properties

    private lazy var backView: UIView = .init()
    private lazy var textField: InputTextField = .init(
        leftPadding: settings.leftPadding,
        rightPadding: settings.rightPadding
    )
    private lazy var topTitleLabel: UILabel = .init()
    private lazy var bottomTitleLabel: UILabel = .init()

    private var settings = InputTextFieldSettings()

    // MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupTextField()
        setupTitles()
        decorate()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("not implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        textField.subviews.forEach {
            if let button = $0 as? UIButton {
                button.setImage(settings.clearButtonImage?.withRenderingMode(.alwaysTemplate), for: .normal)
                button.tintColor = settings.clearButtonImageColor
            }
        }
    }

    // MARK: - Public Methods

    func apply(settings: InputTextFieldSettings) {
        self.settings = settings
        setupPlaceholders()
    }

    func decorate(_ isTopTitle: Bool = true) {
        var topAlpha: CGFloat = 0
        var bottomAlpha: CGFloat = 0
        if isTopTitle {
            topAlpha = text.isEmpty ? 0 : 1
            if text.isEmpty {
                textField.backgroundColor = settings.startBackground
                textField.layer.borderWidth = settings.startBorderWidth
                textField.layer.borderColor = settings.startBorderColor?.cgColor
            } else {
                textField.backgroundColor = settings.fillBackground
                textField.layer.borderWidth = settings.fillBorderWidth
                textField.layer.borderColor = settings.fillBorderColor?.cgColor
            }
            textField.attributedPlaceholder = NSAttributedString(
                string: settings.placeholderText ?? "",
                attributes: settings.placeholderAttributes
            )
        } else {
            bottomAlpha = !text.isEmpty ? 0 : 1
            topAlpha = text.isEmpty ? 0 : 1
            if text.isEmpty {
                textField.backgroundColor = settings.startBackground
                textField.layer.borderWidth = settings.startBorderWidth
                textField.layer.borderColor = settings.bottomTitleColor?.withAlphaComponent(0.2).cgColor
                var attributes = settings.placeholderAttributes
                attributes?[.foregroundColor] = settings.bottomTitleColor
                textField.attributedPlaceholder = NSAttributedString(
                    string: settings.placeholderText ?? "",
                    attributes: attributes
                )
            }
        }

        textField.layer.cornerRadius = settings.radius

        UIView.animate(withDuration: 0.1) {
            self.bottomTitleLabel.alpha = bottomAlpha
            self.topTitleLabel.alpha = topAlpha
        }
    }

    // MARK: - Private Methods

    private func setupTextField() {
        textField.snap(parent: self) {
            $0.autocorrectionType = .no
            $0.clearButtonMode = .never
            $0.delegate = self
        } layout: {
            $0.top.leading.trailing.bottom.equalTo($1)
        }
    }

    private func setupTitles() {
        topTitleLabel.snap(parent: self) {
            $0.text = self.settings.topTitleText
            $0.textColor = self.settings.topTitleColor
            $0.font = self.settings.titleFont
            $0.backgroundColor = .white
            $0.textAlignment = .left
            $0.alpha = 0
        } layout: {
            $0.top.equalTo($1).offset(-8.5)
            $0.height.equalTo(17)
            $0.leading.equalTo(self.settings.leftPadding)
        }

        bottomTitleLabel.snap(parent: self) {
            $0.text = self.settings.bottomTitleText
            $0.textColor = self.settings.bottomTitleColor
            $0.font = self.settings.titleFont
            $0.backgroundColor = .white
            $0.textAlignment = .left
            $0.alpha = 0
        } layout: {
            $0.bottom.equalTo($1).offset(8.5)
            $0.height.equalTo(17)
            $0.leading.equalTo(self.settings.leftPadding)
        }
    }

    private func setupPlaceholders() {
        topTitleLabel.text = " " + (settings.placeholderText ?? "") + " "
        bottomTitleLabel.text = " " + (settings.bottomTitleText ?? "") + " "
        textField.attributedPlaceholder = NSAttributedString(
            string: settings.placeholderText ?? "",
            attributes: settings.placeholderAttributes
        )
    }
}

// MARK: - InputTextView (UITextFieldDelegate)

extension InputTextView: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        onTextBeginEditing?(textField.text ?? "")
    }

    func textField(
        _ textField: UITextField,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String
    ) -> Bool {
        let newString = ((textField.text ?? "") as NSString).replacingCharacters(in: range, with: string)
        textField.text = newString.firstUppercased
        decorate()

        onTextChanged?(newString)

        return false
    }

    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        decorate()
        onTextChanged?("")
        return true
    }
}

// MARK: - InputTextField

private class InputTextField: UITextField {

    // MARK: - Private Properties

    private var leftPadding = CGFloat(0.0)
    private var rightPadding = CGFloat(0.0)
    private lazy var padding = UIEdgeInsets(top: 4, left: leftPadding, bottom: 0, right: rightPadding + 4)

    // MARK: - Lifecycle

    init(leftPadding: CGFloat, rightPadding: CGFloat) {
        self.leftPadding = leftPadding
        self.rightPadding = rightPadding
        super.init(frame: .zero)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("not implemented")
    }

    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
}
