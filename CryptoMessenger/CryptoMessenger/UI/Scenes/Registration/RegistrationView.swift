import PhoneNumberKit
import UIKit

// MARK: - RegistrationView

final class RegistrationView: UIView {

    // MARK: - Type

    typealias Country = CountryCodePickerViewController.Country

    // MARK: - Internal Properties

    var didTapNextScene: StringBlock?
    var didTapCountryScene: VoidBlock?

    // MARK: - Private Properties

    private lazy var titleLabel = UILabel()
    private lazy var descriptionLabel = UILabel()
    private lazy var countryView = UIView()
    private lazy var countryLabel = UILabel()
    private lazy var arrowImageView = UIImageView()
    private lazy var countryButton = UIButton()
    private lazy var phoneView = UIView()
    private lazy var phoneTextField = CountryPhoneNumberTextField()
    private lazy var lineView = UIView()
    private lazy var continueButton = UIButton()

    private var continueButtonDefaultOffset = CGFloat(28)
    private var keyboardObserver: KeyboardObserver?

    // MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        addDismissOnTap(true)
        background(.white())
        addTitleLabel()
        addDescriptionLabel()
        addCountryView()
        addCountryLabel()
        addArrowImageView()
        addCountryButton()
        addPhoneView()
        addPhoneTextField()
        addContinueButton()
        addLineView()
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("not implemented")
    }

    // MARK: - Actions

    @objc private func countryButtonTap() {
        vibrate()
        countryView.animateScaleEffect { self.didTapCountryScene?() }
    }

    @objc private func continueButtonTap() {
        vibrate()
        continueButton.animateScaleEffect {
            let phone = self.phoneTextField.phoneNumber?.numberString ?? ""
            self.didTapNextScene?(phone)
        }
    }

    // MARK: - Internal Methods

    func setCountryCode(_ country: CountryCodePickerViewController.Country) {
        phoneTextField.didSelectCountry(country)
        phoneTextField.defaultRegion = country.code
        countryLabel.text = country.prefix + " " + country.name.firstUppercased
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
        continueButton.snp.updateConstraints {
            $0.bottom.equalTo(self.snp_bottomMargin).offset(-offset)
        }
        UIView.animate(withDuration: 0.25) { self.layoutIfNeeded() }
    }

    // MARK: - Private Methods

    private func addTitleLabel() {
        titleLabel.snap(parent: self) {
            $0.text = R.string.localizable.registrationTitle()
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
            $0.text = R.string.localizable.registrationDescription()
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

    private func addCountryView() {
        countryView.snap(parent: self) {
            $0.background(.lightGray())
            $0.clipCorners(radius: 8)
        } layout: {
            $0.top.equalTo(self.descriptionLabel.snp.bottom).offset(50)
            $0.leading.equalTo($1).offset(24)
            $0.trailing.equalTo($1).offset(-24)
            $0.height.equalTo(44)
        }
    }

    private func addCountryLabel() {
        countryLabel.snap(parent: countryView) {
            $0.font(.regular(15))
            $0.textColor(.black())
            $0.textAlignment = .left
        } layout: {
            $0.centerY.equalTo($1)
            $0.leading.equalTo($1).offset(16)
        }
    }

    private func addArrowImageView() {
        arrowImageView.snap(parent: countryView) {
            $0.image = R.image.registration.arrow()
        } layout: {
            $0.centerY.equalTo($1)
            $0.leading.equalTo(self.countryLabel.snp.trailing).offset(16)
            $0.trailing.equalTo($1).offset(-10)
            $0.width.height.equalTo(24)
        }
    }

    private func addCountryButton() {
        countryButton.snap(parent: countryView) {
            $0.background(.clear)
            $0.addTarget(self, action: #selector(self.countryButtonTap), for: .touchUpInside)
        } layout: {
            $0.top.leading.trailing.bottom.equalTo($1)
        }
    }

    private func addPhoneView() {
        phoneView.snap(parent: self) {
            $0.background(.lightGray())
            $0.clipCorners(radius: 8)
        } layout: {
            $0.top.equalTo(self.countryView.snp.bottom).offset(32)
            $0.leading.equalTo($1).offset(24)
            $0.trailing.equalTo($1).offset(-24)
            $0.height.equalTo(44)
        }
    }

    private func addPhoneTextField() {
        phoneTextField.snap(parent: phoneView) {
            $0.placeholder = "Введите номер"
            $0.font(.regular(15))
            $0.textColor(.black())
            $0.textAlignment = .left
            $0.autocorrectionType = .no
            $0.withPrefix = false
            $0.withFlag = false
        } layout: {
            $0.top.bottom.equalTo($1)
            $0.leading.equalTo($1).offset(16)
            $0.trailing.equalTo($1).offset(-16)
        }
        phoneTextField.didNumberChanged = { isValid in
            let title = R.string.localizable.registrationContinueButton()
            self.continueButton.isEnabled = isValid
            if isValid {
                self.continueButton.background(.lightBlue())
                self.continueButton.titleAttributes(text: title, [.color(.blue()), .font(.medium(15))])
            } else {
                self.continueButton.background(.lightGray())
                self.continueButton.titleAttributes(text: title, [.color(.gray()), .font(.medium(15))])
            }
        }
    }

    private func addContinueButton() {
        continueButton.snap(parent: self) {
            let title = R.string.localizable.registrationContinueButton()
            $0.titleAttributes(text: title, [.color(.gray()), .font(.medium(15))])
            $0.background(.lightGray())
            $0.clipCorners(radius: 8)
            $0.isEnabled = false
            $0.addTarget(self, action: #selector(self.continueButtonTap), for: .touchUpInside)
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
            $0.bottom.equalTo(self.continueButton.snp.top).offset(-8)
            $0.leading.trailing.equalTo($1)
            $0.height.equalTo(1)
        }
    }

    // MARK: - CountryPhoneNumberTextField

    final class CountryPhoneNumberTextField: PhoneNumberTextField {

        // MARK: - Internal Properties

        var didNumberChanged: ((Bool) -> Void)?

        override var defaultRegion: String {
            get { PhoneHelper.userRegionCode }
            set {}
        }

        override var text: String? {
            get { super.text }
            set {
                let finalText = parseInput(input: newValue)
                if let country = selectedCountry {
                    defaultRegion = country.code
                }
                didNumberChanged?(PhoneHelper.validatePhoneNumber(finalText ?? "", forRegion: defaultRegion))
                super.text = finalText
            }
        }

        var formattedText: String? {
            if let text = text, let selectedCountry = selectedCountry {
                return PhoneHelper.formatToInternationalNumber(text, forRegion: selectedCountry.code)
            }
            return nil
        }

        // MARK: - Private Properties

        private var selectedCountry = CountryCodePickerViewController.baseCountry

        // MARK: - Internal Methods

        func didSelectCountry(_ country: Country) {
            selectedCountry = country
            defaultRegion = country.code
            text = formattedText
        }

        // MARK: - Private Methods

        private func parseInput(input: String?) -> String? {
            guard let input = input, let code = selectedCountry?.code else { return nil }
            return PhoneHelper.formatToNationalNumber(input, forRegion: code) ?? input
        }
    }
}
