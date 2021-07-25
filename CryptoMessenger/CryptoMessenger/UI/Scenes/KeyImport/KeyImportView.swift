import UIKit

// MARK: - KeyImportView

final class KeyImportView: UIView {

    // MARK: - Internal Properties

    var didTapImportButton: VoidBlock?

    // MARK: - Private Properties

    private lazy var titleLabel = UILabel()
    private lazy var keyTextView = UITextView()
    private lazy var lineView = UIView()
    private lazy var importButton = LoadingButton()
    private lazy var infoButton = UIButton()

    private let keyPlaceholder = R.string.localizable.keyImportTextPlaceholder()
    private var continueButtonDefaultOffset = CGFloat(28)
    private var keyboardObserver: KeyboardObserver?

    // MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        addDismissOnTap(true)
        background(.white())
        addTitleLabel()
        addKeyTextView()
        addImportButton()
        addLineView()
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("not implemented")
    }

    // MARK: - Internal Methods

    func startLoading() {
        importButton.showLoader(userInteraction: false)
    }

    func stopLoading() {
        importButton.hideLoader()
    }

    func subscribeOnKeyboardNotifications() {
        guard keyboardObserver == nil else { return }

        keyboardObserver = KeyboardObserver()
        keyboardObserver?.keyboardWillShowHandler = { [weak self] notification in
            guard
                let userInfo = notification.userInfo,
                let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            else {
                return
            }
            self?.updateContinueButtonConstraints(keyboardFrame.size.height - 20)
        }
        keyboardObserver?.keyboardWillHideHandler = { [weak self] _ in
            self?.updateContinueButtonConstraints(nil)
        }
    }

    func unsubscribeKeyboardNotifications() {
        keyboardObserver = nil
    }

    func updateContinueButtonConstraints(_ offset: CGFloat?) {
        let offset = offset ?? continueButtonDefaultOffset
        importButton.snp.updateConstraints {
            $0.bottom.equalTo(self.snp_bottomMargin).offset(-offset)
        }
        UIView.animate(withDuration: 0.25) { self.layoutIfNeeded() }
    }

    // MARK: - Actions

    @objc private func importButtonTap() {
        vibrate()

        importButton.indicator = MaterialLoadingIndicator(color: .blue())
        importButton.animateScaleEffect {
            self.startLoading()
            self.didTapImportButton?()
        }
    }

    // MARK: - Private Methods

    private func addTitleLabel() {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.15
        paragraphStyle.alignment = .center

        titleLabel.snap(parent: self) {
            $0.titleAttributes(
                text: R.string.localizable.keyImportTitle(),
                [
                    .paragraph(paragraphStyle),
                    .font(.medium(22)),
                    .color(.black())
                ]
            )
            $0.textAlignment = .center
            $0.numberOfLines = 0
        } layout: {
            $0.top.equalTo(self.snp_topMargin).offset(50)
            $0.leading.equalTo($1).offset(24)
            $0.trailing.equalTo($1).offset(-24)
            $0.height.greaterThanOrEqualTo(28)
        }
    }

    private func addKeyTextView() {
        keyTextView.snap(parent: self) {
            $0.delegate = self
            $0.text = self.keyPlaceholder
            $0.font(.regular(15))
            $0.textColor(.gray())
            $0.background(.lightGray())
            $0.clipCorners(radius: 8)
            $0.textContainerInset = .init(top: 16, left: 16, bottom: 16, right: 16)
            $0.autocorrectionType = .no
            $0.textAlignment = .left
            $0.layer.borderWidth = 1
            $0.layer.borderColor = #colorLiteral(red: 0.9019607843, green: 0.9176470588, blue: 0.9294117647, alpha: 1).cgColor
            $0.selectedTextRange = $0.textRange(from: $0.beginningOfDocument, to: $0.beginningOfDocument)
        } layout: {
            $0.top.equalTo(self.titleLabel.snp_bottomMargin).offset(160)
            $0.leading.equalTo($1).offset(16)
            $0.trailing.equalTo($1).offset(-16)
            $0.height.greaterThanOrEqualTo(100)
        }
    }

    private func addImportButton() {
        importButton.snap(parent: self) {
            let title = R.string.localizable.keyImportImportButton()
            $0.titleAttributes(text: title, [.color(.gray()), .font(.medium(15))])
            $0.background(.lightGray())
            $0.clipCorners(radius: 8)
            $0.isUserInteractionEnabled = false
            $0.addTarget(self, action: #selector(self.importButtonTap), for: .touchUpInside)
        } layout: {
            $0.leading.equalTo($1).offset(80)
            $0.trailing.equalTo($1).offset(-80)
            $0.height.equalTo(44)
            $0.bottom.equalTo(self.snp_bottomMargin).offset(-28)
        }
    }

    private func addLineView() {
        lineView.snap(parent: self) {
            $0.background(.lightGray())
        } layout: {
            $0.bottom.equalTo(self.importButton.snp.top).offset(-8)
            $0.leading.trailing.equalTo($1)
            $0.height.equalTo(1)
        }
    }
}

// MARK: - KeyImportView (UITextViewDelegate)

extension KeyImportView: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == Palette.gray().uiColor {
            textView.text = nil
            textView.textColor(.black())
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = keyPlaceholder
            textView.textColor(.gray())
        }
    }

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {

        let newString = ((textView.text ?? "") as NSString).replacingCharacters(in: range, with: text)
        textView.text = newString

        let title = R.string.localizable.keyImportImportButton()
        if !newString.isEmpty {
            importButton.background(.lightBlue())
            importButton.titleAttributes(text: title, [.color(.blue()), .font(.medium(15))])
        } else {
            importButton.background(.lightGray())
            importButton.titleAttributes(text: title, [.color(.gray()), .font(.medium(15))])
        }
        importButton.isUserInteractionEnabled = !newString.isEmpty

        return false
    }
}
