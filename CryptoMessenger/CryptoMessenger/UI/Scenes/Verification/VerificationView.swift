import UIKit

// MARK: - VerificationView

final class VerificationView: UIView {

    // MARK: - Internal Properties

    var didTapNextScene: StringBlock?
    var didTapResendButton: VoidBlock?

    // MARK: - Private Properties

    private lazy var titleLabel = UILabel()
    private lazy var descriptionLabel = UILabel()
    private lazy var codeTextField = UITextField()
    private lazy var dotesStackView = UIStackView()
    private lazy var dotes: [UILabel] = []
    private lazy var timerLabel = UILabel()
    private lazy var resendButton = LoadingButton()

    // MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        background(.white())
        addTitleLabel()
        addDescriptionLabel()
        addCodeTextField()
        addDotes()
        addTimerLabel()
        addResendButton()
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("not implemented")
    }

    // MARK: - Internal Methods

    func setPhoneNumber(_ phone: String) {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.24
        paragraphStyle.alignment = .center

        descriptionLabel.titleAttributes(
            text: R.string.localizable.verificationDescription(phone),
            [
                .paragraph(paragraphStyle),
                .font(.regular(15)),
                .color(.gray())
            ]
        )
    }

    func setResult(_ isSucceed: Bool) {
        dotes.forEach { $0.textColor(isSucceed ? .blue() : .red()) }
    }

    func setCountdownTime(_ time: String) {
        if timerLabel.isHidden {
            timerLabel.snp.updateConstraints {
                $0.height.greaterThanOrEqualTo(43)
            }
            timerLabel.isHidden = false
            resendButton.isHidden = true
        }

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.24
        paragraphStyle.alignment = .center

        timerLabel.titleAttributes(
                text: R.string.localizable.verificationResendTitle(time),
                [
                    .paragraph(paragraphStyle),
                    .font(.regular(15)),
                    .color(.blue())
                ]
            )
    }

    func resetCountdownTime() {
        timerLabel.snp.updateConstraints {
            $0.height.greaterThanOrEqualTo(0)
        }
        timerLabel.isHidden = true
        resendButton.isHidden = false
    }

    func startLoading() {
        resendButton.showLoader(userInteraction: false)
    }

    func stopLoading() {
        resendButton.hideLoader()
    }

    // MARK: - Actions

    @objc private func continueButtonTap() {
        vibrate()

        resendButton.indicator = MaterialLoadingIndicator(color: .blue())
        resendButton.animateScaleEffect {
            self.startLoading()
            self.didTapResendButton?()
        }
    }

    // MARK: - Private Methods

    private func addTitleLabel() {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.15
        paragraphStyle.alignment = .center

        titleLabel.snap(parent: self) {
            $0.titleAttributes(
                text: R.string.localizable.verificationTitle(),
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

    private func addDescriptionLabel() {
        descriptionLabel.snap(parent: self) {
            $0.textAlignment = .center
            $0.numberOfLines = 0
        } layout: {
            $0.top.equalTo(self.titleLabel.snp.bottom).offset(12)
            $0.leading.equalTo($1).offset(24)
            $0.trailing.equalTo($1).offset(-24)
        }
    }

    private func addCodeTextField() {
        codeTextField.snap(parent: self) {
            $0.keyboardType = .numberPad
            $0.isHidden = true
            $0.delegate = self
            $0.becomeFirstResponder()
        } layout: {
            $0.top.equalTo($1)
            $0.leading.equalTo($1)
        }
    }

    private func addDotes() {
        (0..<PhoneHelper.verificationCodeRequiredLength).forEach { _ in
            let label = UILabel()
            label.font(.regular(28))
            label.textAlignment = .center
            label.text = "—"
            label.textColor(.black())

            label.snp.makeConstraints {
                $0.width.equalTo(40)
                $0.height.equalTo(25)
            }

            dotes.append(label)
            dotesStackView.addArrangedSubview(label)
        }

        dotesStackView.snap(parent: self) {
            $0.alignment = .fill
            $0.axis = .horizontal
            $0.spacing = 16
        } layout: {
            $0.top.equalTo(self.descriptionLabel.snp_bottomMargin).offset(100)
            $0.centerX.equalTo($1)
            $0.height.equalTo(25)
        }
    }

    private func addTimerLabel() {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.24
        paragraphStyle.alignment = .center

        let time = Int(PhoneHelper.verificationResendTime).description

        timerLabel.snap(parent: self) {
            $0.titleAttributes(
                text: R.string.localizable.verificationResendTitle(time),
                [
                    .paragraph(paragraphStyle),
                    .font(.regular(15)),
                    .color(.blue())
                ]
            )
            $0.textAlignment = .center
            $0.numberOfLines = 0
        } layout: {
            $0.top.equalTo(self.dotesStackView.snp.bottom).offset(50)
            $0.leading.equalTo($1).offset(47)
            $0.height.greaterThanOrEqualTo(43)
            $0.trailing.equalTo($1).offset(-47)
        }
    }

    private func addResendButton() {
        let paragraph = NSMutableParagraphStyle()
        paragraph.lineHeightMultiple = 1.09
        paragraph.alignment = .center

        resendButton.snap(parent: self) {
            let title = R.string.localizable.verificationResendButton()
            $0.titleAttributes(
                text: title,
                [
                    .color(.white()),
                    .font(.semibold(15)),
                    .paragraph(paragraph)
                ]
            )
            $0.background(.blue())
            $0.clipCorners(radius: 8)
            $0.isHidden = true
            $0.addTarget(self, action: #selector(self.continueButtonTap), for: .touchUpInside)
        } layout: {
            $0.top.equalTo(self.timerLabel.snp_bottomMargin).offset(8)
            $0.leading.equalTo($1).offset(80)
            $0.trailing.equalTo($1).offset(-80)
            $0.height.equalTo(44)
        }
    }
}

// MARK: - VerificationView (UITextFieldDelegate)

extension VerificationView: UITextFieldDelegate {
    func textField(
        _ textField: UITextField,
        shouldChangeCharactersIn range: NSRange, replacementString string: String
    ) -> Bool {
        let newString = ((textField.text ?? "") as NSString).replacingCharacters(in: range, with: string)

        dotes.forEach { $0.textColor(.black()) }

        guard newString.count <= PhoneHelper.verificationCodeRequiredLength else { return false }

        textField.text = newString

        (newString.count..<PhoneHelper.verificationCodeRequiredLength).forEach { index in
            dotes[index].text = "-"
        }

        newString.enumerated().forEach { result in
            dotes[result.offset].text = result.element.description
        }

        if newString.count == PhoneHelper.verificationCodeRequiredLength {
            didTapNextScene?(newString)
        }

        return false
    }
}
