import UIKit

// MARK: - SecurityPinCodeView

final class SecurityPinCodeView: UIView {

    // MARK: - ButtonType

    enum ButtonType: Hashable {

        // MARK: - Types

        case number(Int)
        case faceId
        case delete
    }

    // MARK: - PinButton

    final class PinButton: UIButton {

        // MARK: - Internal Properties

        var type: SecurityPinCodeView.ButtonType = .delete
    }

    // MARK: - Internal Properties

    var didTapAuth: VoidBlock?
    var didAuthSuccess: VoidBlock?
    var didSetNewPinCode: StringBlock?

    // MARK: - Private Properties

    private lazy var titleLabel = UILabel()
    private lazy var passwordLabel = UILabel()
    private lazy var enterButton = UIButton()
    private lazy var dotes: [UIView] = []
    private lazy var dotesStackView = UIStackView()
    private lazy var firstStackView = UIStackView()
    private lazy var secondStackView = UIStackView()
    private lazy var thirdStackView = UIStackView()
    private lazy var fourthStackView = UIStackView()
    private lazy var unionStackView = UIStackView(arrangedSubviews: [
        createStackView(stackView: firstStackView),
        createStackView(stackView: secondStackView),
        createStackView(stackView: thirdStackView),
        createStackView(stackView: fourthStackView)
    ])
    private var buttons: [PinButton] = []
    private var userCode: [Int] = []
    private var rightCode: [Int] = []
    private let maxDotesCount = 5
    private var isNewPassword = true
    private var isFirstStep = true
    private var isPasswordNotMatched = false
    private var isPasswordSuccess = false

    @Injectable private var userFlows: UserFlowsStorageService
    @Injectable private var userCredentials: UserCredentialsStorageService

    // MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        background(.white())
        createButtons()
        addTitleLabel()
        addPasswordLabel()
        addDotes()
        addUnionStack()
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("not implemented")
    }

    // MARK: - Internal Methods

    func setPinCode(_ pinCode: [Int]) {
        print("pinCode    \(pinCode)")
        print(isNewPassword)
        rightCode = pinCode
        isNewPassword = pinCode.isEmpty
        stylePasswordTitle()
    }

    func nextPage() {
        styleDotes()
        didAuthSuccess?()
    }

    // MARK: - Actions

    @objc private func authButtonTap() {
        didTapAuth?()
    }

    @objc private func numberButtonAction(sender: PinButton) {
        guard case let .number(number) = sender.type else { return }

        vibrate()

        if userCode.count < maxDotesCount {
            userCode.append(number)
            for item in 0..<userCode.count {
                dotes[item].background(.blue())
            }
        }

        if userCode.count == maxDotesCount {
            if isNewPassword {
                processNewPassword()
                return
            }

            if userCode != rightCode {
                print("!+ \(rightCode)")
                dotes.forEach { $0.background(.red()) }
                delay(0.1) {
                    self.dotesStackView.shake(duration: 0.4)
                    vibrate(.heavy)
                }
            } else {
                self.nextPage()
            }
        }
    }

    @objc private func deleteButtonAction(sender: UIButton) {
        if !userCode.isEmpty { userCode.removeLast() }
        isPasswordNotMatched = false
        isPasswordSuccess = false
        stylePasswordTitle()
        styleDotes()
    }

    // MARK: - Private Methods

    private func stylePasswordTitle() {
        var title = ""
        var text = ""
        if userFlows.isFalsePinCodeOn {
            title = R.string.localizable.pinCodeFalseTitle()
            text = R.string.localizable.pinCodeFalseText()
            passwordLabel.numberOfLines = 3
        } else {
            if isFirstStep {
                title = R.string.localizable.pinCodeNewPassword()
            } else {
                title = R.string.localizable.pinCodeRepeatPassword()
            }
            if isPasswordNotMatched {
                title = R.string.localizable.pinCodeNotMatchPassword()
            }
            if isPasswordSuccess {
                title = R.string.localizable.pinCodeSuccessPassword()
            }
        }
        if userCredentials.userFalsePinCode.isEmpty == true {
            title = R.string.localizable.pinCodeCreateTitle()
            text = R.string.localizable.pinCodeCreateText()
            if isFirstStep {
                title = R.string.localizable.pinCodeNewPassword()
            } else {
                title = R.string.localizable.pinCodeRepeatPassword()
            }
            if isPasswordNotMatched {
                title = R.string.localizable.pinCodeNotMatchPassword()
            }
            if isPasswordSuccess {
                title = R.string.localizable.pinCodeSuccessPassword()
            }
        }
        if userCredentials.userPinCode.isEmpty == true {
            title = R.string.localizable.pinCodeCreateTitle()
            text = R.string.localizable.pinCodeCreateText()
            if isFirstStep {
                title = R.string.localizable.pinCodeNewPassword()
            } else {
                title = R.string.localizable.pinCodeRepeatPassword()
            }
            if isPasswordNotMatched {
                title = R.string.localizable.pinCodeNotMatchPassword()
            }
            if isPasswordSuccess {
                title = R.string.localizable.pinCodeSuccessPassword()
            }
        }

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.15
        paragraphStyle.alignment = .center
        titleLabel.titleAttributes(
            text: title,
            [
                .paragraph(paragraphStyle),
                .font(.bold(30)),
                .color(.black())
            ]
        )
        passwordLabel.titleAttributes(
            text: text,
            [
                .paragraph(paragraphStyle),
                .font(.regular(15)),
                .color(.black())
            ]
        )
        passwordLabel.numberOfLines = 3
    }

    private func processNewPassword() {
        if !isFirstStep {
            if rightCode == userCode {
                isPasswordNotMatched = false
                isPasswordSuccess = true
                stylePasswordTitle()
                styleDotes()
                didSetNewPinCode?(rightCode.reduce("", { result, number in
                    result + number.description
                }))
            } else {
                isPasswordNotMatched = true
                isPasswordSuccess = false
                stylePasswordTitle()
                dotes.forEach { $0.background(.red()) }
                delay(0.1) {
                    self.dotesStackView.shake(duration: 0.4)
                    vibrate(.heavy)
                }
            }
            return
        }

        rightCode = userCode

        UIView.animate(withDuration: 0.2, delay: 0, options: .transitionCrossDissolve) {
            self.dotesStackView.alpha = 0
        } completion: { _ in
            UIView.animate(withDuration: 0.1, delay: 0.05, options: .transitionCrossDissolve) {
                self.dotesStackView.alpha = 1
            } completion: { _ in
                self.isFirstStep = false
                self.userCode = []
                self.styleDotes()
                self.stylePasswordTitle()
            }
        }
    }

    private func createButtons() {
        let firstButtons = (1...3).map { createButton(.number($0)) }
        firstButtons.forEach { firstStackView.addArrangedSubview($0) }
        let secondButtons = (4...6).map { createButton(.number($0)) }
        secondButtons.forEach { secondStackView.addArrangedSubview($0) }
        let thirdButtons = (7...9).map { createButton(.number($0)) }
        thirdButtons.forEach { thirdStackView.addArrangedSubview($0) }
        let fourthButtons = [createButton(.faceId), createButton(.number(0)), createButton(.delete)]
        fourthButtons.forEach { fourthStackView.addArrangedSubview($0) }

        buttons.append(contentsOf: firstButtons + secondButtons + thirdButtons + fourthButtons)
    }

    private func createButton(_ type: ButtonType) -> PinButton {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 0.98
        paragraphStyle.alignment = .center

        let button = PinButton()
        button.type = type
        button.snp.makeConstraints { $0.width.height.equalTo(67) }
        button.clipCorners(radius: 33.5)
        switch type {
        case let .number(value):
            button.titleAttributes(
                text: value.description,
                [
                    .font(.regular(24)),
                    .color(.black()),
                    .paragraph(paragraphStyle)
                ]
            )
            button.setBackgroundColor(color: .paleBlue(), forState: .normal)
            button.setBackgroundColor(color: .lightBlue(), forState: .highlighted)
            button.addTarget(self, action: #selector(numberButtonAction), for: .touchUpInside)
        case .faceId:
            button.addTarget(self, action: #selector(authButtonTap), for: .touchUpInside)
            button.isEnabled = true
        case .delete:
            button.setImage(R.image.pinCode.delete(), for: .normal)
            button.addTarget(self, action: #selector(deleteButtonAction), for: .touchUpInside)
        }
        return button
    }

    private func createStackView(stackView: UIStackView) -> UIStackView {
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.alignment = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }

    private func styleDotes() {
        dotes.enumerated().forEach {
            if (0..<userCode.count).contains($0.offset) {
                $0.element.background(.blue())
            } else {
                $0.element.background(.paleBlue())
            }
        }
    }

    private func addTitleLabel() {
        titleLabel.snap(parent: self) {
            $0.textAlignment = .center
        } layout: {
            $0.centerX.equalTo($1)
            $0.height.equalTo(30)
            $0.top.equalTo(self.snp.topMargin).offset(34)
        }
    }

    private func addPasswordLabel() {
        passwordLabel.snap(parent: self) {
            $0.textAlignment = .center
        } layout: {
            $0.leading.equalTo($1).offset(24)
            $0.trailing.equalTo($1).offset(-24)
            if self.userFlows.isFalsePinCodeOn {
                $0.height.equalTo(64)
            }
            $0.top.equalTo(self.titleLabel.snp.bottom).offset(16)
        }
    }

    private func addUnionStack() {
        unionStackView.snap(parent: self) {
            $0.axis = .vertical
            $0.spacing = 25
            $0.distribution = .fillEqually
            $0.alignment = .fill
        } layout: {
            $0.centerX.equalTo($1)
            $0.leading.equalTo($1).offset(54)
            $0.trailing.equalTo($1).offset(-54)
            $0.top.equalTo(self.dotesStackView.snp.bottom).offset(60)
        }
    }

    private func addDotes() {
        (0..<5).forEach { _ in
            let view = UIView()
            view.background(.lightBlue())
            view.snp.makeConstraints {
                $0.width.height.equalTo(14)
            }
            view.clipCorners(radius: 7)
            dotes.append(view)
            dotesStackView.addArrangedSubview(view)
        }
        dotesStackView.snap(parent: self) {
            $0.alignment = .fill
            $0.axis = .horizontal
            $0.spacing = 16
        } layout: {
            $0.top.equalTo(self.passwordLabel.snp.bottom).offset(36)
            $0.centerX.equalTo($1)
        }
    }
}
