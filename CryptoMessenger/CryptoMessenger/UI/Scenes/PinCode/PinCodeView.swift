import LocalAuthentication
import UIKit

// MARK: - PinCodeView

final class PinCodeView: UIView {

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

        var type: PinCodeView.ButtonType = .delete
    }

    // MARK: - Internal Properties

    var didTapAuth: VoidBlock?
    var didAuthSuccess: VoidBlock?

    // MARK: - Private Properties

    private lazy var auraImage = UIImageView()
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
    private var rightCode = [1, 2, 3, 4, 5]
    private let maxDotesCount = 5

    // MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        background(.white())
        createButtons()
        addAuraImage()
        addPasswordLabel()
        addDotes()
        addUnionStack()
        addEnterButton()
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("not implemented")
    }

    // MARK: - Internal Methods

    func setLocalAuth(_ result: AvailableBiometric?) {
        guard let result = result, let button = buttons.first(where: { $0.type == .faceId }) else { return }
        button.isEnabled = true
        button.setImage(result.image, for: .normal)
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
        vibrate()

        if userCode.count < maxDotesCount {
            guard let index = buttons.firstIndex(of: sender) else { return }
            userCode.append(index)
            for item in 0..<userCode.count {
                dotes[item].background(.blue())
            }
        }
        if userCode.count == maxDotesCount {
            if userCode == userCode {
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
        styleDotes()
    }

    // MARK: - Private Methods

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
            button.isEnabled = false
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

    private func addAuraImage() {
        auraImage.snap(parent: self) {
            $0.image = R.image.pinCode.aura()
            $0.contentMode = .scaleAspectFill
        } layout: {
            $0.top.equalTo(self.snp_topMargin).offset(67)
            $0.width.height.equalTo(58)
            $0.centerX.equalTo($1)
        }
    }

    private func addPasswordLabel() {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.15
        paragraphStyle.alignment = .center
        passwordLabel.snap(parent: self) {
            $0.titleAttributes(
                text: R.string.localizable.pinCodePassword(),
                [
                    .paragraph(paragraphStyle),
                    .font(.medium(21)),
                    .color(.black())
                ]
            )
            $0.textAlignment = .center
        } layout: {
            $0.top.equalTo(self.auraImage.snp.bottom).offset(33)
            $0.centerX.equalTo($1)
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
            $0.top.equalTo(self.passwordLabel.snp.bottom).offset(32)
            $0.centerX.equalTo($1)
        }
    }

    private func addEnterButton() {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.15
        paragraphStyle.alignment = .center
        enterButton.snap(parent: self) {
            $0.titleAttributes(
                text: R.string.localizable.pinCodeEnter(),
                [
                    .paragraph(paragraphStyle),
                    .font(.medium(15)),
                    .color(.blue())
                ]
            )
        } layout: {
            $0.centerX.equalTo($1)
            $0.height.equalTo(22)
            $0.bottom.equalTo(self.unionStackView.snp.bottom).offset(80)
        }
    }
}
