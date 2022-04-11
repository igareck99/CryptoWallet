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
    private lazy var phoneTextField = CustomTextField()
    private lazy var lineView = UIView()
    private lazy var continueButton = LoadingButton()

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
        continueButton.indicator = MaterialLoadingIndicator(color: .blue())
        continueButton.animateScaleEffect {
            self.startLoading()
            let phone = self.phoneTextField.phoneNumber?.numberString ?? ""
            self.didTapNextScene?(phone)
        }
    }

    @objc private func onTextUpdate(textField: PhoneNumberTextField) {
        styleControls()
    }

    // MARK: - Internal Methods

    func startLoading() {
        continueButton.showLoader(userInteraction: false)
    }

    func stopLoading() {
        continueButton.hideLoader()
    }

    func setCountryCode(_ country: CountryCodePickerViewController.Country) {
        phoneTextField.selectedCountry = country
        phoneTextField.partialFormatter.defaultRegion = country.code
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
            self?.updateContinueButtonConstraints(keyboardFrame.size.height + 10)
        }
        keyboardObserver?.keyboardWillHideHandler = { [weak self] _ in
            self?.updateContinueButtonConstraints(nil)
        }
        phoneTextField.becomeFirstResponder()
        styleControls()
    }

    func unsubscribeKeyboardNotifications() {
        keyboardObserver = nil
    }

    func updateContinueButtonConstraints(_ offset: CGFloat?) {
        let offset = offset ?? continueButtonDefaultOffset
        UIView.animate(withDuration: 0.25) {
            self.continueButton.snp.updateConstraints { $0.bottom.equalToSuperview().inset(offset) }
            self.layoutIfNeeded()
        }
    }

    // MARK: - Private Methods

    private func addTitleLabel() {
        titleLabel.snap(parent: self) {
            $0.titleAttributes(
                text: R.string.localizable.registrationTitle(),
                [
                    .paragraph(.init(lineHeightMultiple: 1.15, alignment: .center)),
                    .font(.medium(22)),
                    .color(.black())
                ]
            )
            $0.textAlignment = .center
            $0.numberOfLines = 0
        } layout: {
            $0.top.equalTo(self.snp_topMargin).offset(50)
            $0.leading.trailing.equalTo($1).inset(24)
            $0.height.greaterThanOrEqualTo(28)
        }
    }

    private func addDescriptionLabel() {
        descriptionLabel.snap(parent: self) {
            $0.titleAttributes(
                text: R.string.localizable.registrationDescription(),
                [
                    .paragraph(.init(lineHeightMultiple: 1.24, alignment: .center)),
                    .font(.regular(15)),
                    .color(.gray())
                ]
            )
            $0.textAlignment = .center
            $0.numberOfLines = 0
        } layout: {
            $0.top.equalTo(self.titleLabel.snp.bottom).offset(12)
            $0.leading.trailing.equalTo($1).inset(24)
        }
    }

    private func addCountryView() {
        countryView.snap(parent: self) {
            $0.background(.paleBlue())
            $0.clipCorners(radius: 8)
        } layout: {
            $0.top.equalTo(self.descriptionLabel.snp.bottom).offset(50)
            $0.leading.trailing.equalTo($1).inset(24)
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
            $0.leading.trailing.equalTo($1).inset(16)
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
            $0.background(.paleBlue())
            $0.clipCorners(radius: 8)
        } layout: {
            $0.top.equalTo(self.countryView.snp.bottom).offset(32)
            $0.leading.trailing.equalTo($1).inset(24)
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
            $0.maxDigits = 16
            $0.addTarget(self, action: #selector(self.onTextUpdate), for: .editingChanged)
        } layout: {
            $0.top.bottom.equalTo($1)
            $0.leading.trailing.equalTo($1).inset(16)
        }
    }

    private func addContinueButton() {
        continueButton.snap(parent: self) {
            let title = R.string.localizable.registrationContinueButton()
            $0.titleAttributes(text: title, [.color(.gray()), .font(.semibold(15))])
            $0.background(.lightGray())
            $0.clipCorners(radius: 8)
            $0.isEnabled = false
            $0.addTarget(self, action: #selector(self.continueButtonTap), for: .touchUpInside)
        } layout: {
            $0.leading.trailing.equalTo($1).inset(80)
            $0.height.equalTo(44)
            $0.bottom.equalToSuperview().inset(28)
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

    private func styleControls() {
        let title = R.string.localizable.registrationContinueButton()
        continueButton.isEnabled = phoneTextField.isValidNumber

        if phoneTextField.isValidNumber {
            continueButton.background(.blue())
            continueButton.titleAttributes(text: title, [.color(.white()), .font(.semibold(15))])
        } else {
            continueButton.background(.lightGray())
            continueButton.titleAttributes(text: title, [.color(.gray()), .font(.semibold(15))])
        }
    }

    // MARK: - CustomTextField

    final class CustomTextField: PhoneNumberTextField {

        // MARK: - Internal Properties

        var selectedCountry = CountryCodePickerViewController.baseCountry

        override var defaultRegion: String {
            get { selectedCountry?.code ?? PhoneHelper.userRegionCode }
            set {}
        }
    }
}
