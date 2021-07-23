import UIKit

// MARK: - VerificationView

final class VerificationView: UIView {

    // MARK: - Internal Properties

    var didTapNextScene: StringBlock?

    // MARK: - Private Properties

    private lazy var titleLabel = UILabel()
    private lazy var descriptionLabel = UILabel()
    private lazy var codeTextField = UITextField()
    private lazy var dotesStackView = UIStackView()
    private lazy var dotes: [UILabel] = []
    private lazy var timerLabel = UILabel()

    // MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        background(.white())
        addTitleLabel()
        addDescriptionLabel()
        addCodeTextField()
        addDotes()
        addTimerLabel()
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("not implemented")
    }

    // MARK: - Internal Methods

    func setPhoneNumber(_ phone: String) {
        descriptionLabel.text = R.string.localizable.verificationDescription(phone)
    }

    // MARK: - Private Methods

    private func addTitleLabel() {
        titleLabel.snap(parent: self) {
            $0.text = R.string.localizable.verificationTitle()
            $0.font(.medium(22))
            $0.textColor(.black())
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
            $0.font(.regular(15))
            $0.textColor(.gray())
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
        (0..<PhoneHelper.maxVerificationCodeLength).forEach { _ in
            let label = UILabel()
            label.font(.medium(22))
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
        timerLabel.snap(parent: self) {
            $0.text = R.string.localizable.verificationResendTitle("30")
            $0.font(.regular(15))
            $0.textColor(.blue())
            $0.textAlignment = .center
            $0.numberOfLines = 0
        } layout: {
            $0.top.equalTo(self.dotesStackView.snp.bottom).offset(50)
            $0.leading.equalTo($1).offset(47)
            $0.height.greaterThanOrEqualTo(43)
            $0.trailing.equalTo($1).offset(-47)
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
        textField.text = newString

        (newString.count..<PhoneHelper.maxVerificationCodeLength).forEach { index in
            dotes[index].text = "-"
        }

        newString.enumerated().forEach { result in
            dotes[result.offset].text = result.element.description
        }

        if newString.count == PhoneHelper.maxVerificationCodeLength {
            // send request
        }

        return false
    }
}
