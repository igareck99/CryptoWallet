import UIKit

// MARK: - PinCodeView

final class PinCodeView: UIView {

    // MARK: - ButtonType

    enum ButtonType {
        case number(Int)
        case faceId
        case delete
    }

    // MARK: - Internal Properties

    var didTap: (() -> Void)?

    // MARK: - Private Properties

    private lazy var auraImage = UIImageView()
    private lazy var passwordLabel = UILabel()
    private lazy var enterButton = UIButton()
    private lazy var firstStackView = UIStackView(arrangedSubviews: [buttons[1], buttons[2], buttons[3]])
    private lazy var twoStackView = UIStackView(arrangedSubviews: [buttons[4], buttons[5], buttons[6]])
    private lazy var thirdStackView = UIStackView(arrangedSubviews: [buttons[7], buttons[8], buttons[9]])
    private lazy var fourStackView = UIStackView(arrangedSubviews: [buttons[10], buttons[0], buttons[11]])
    private lazy var dotes: [UIImageView] = []
    private lazy var dotesStackView = UIStackView()
    private lazy var unionStackView = UIStackView(arrangedSubviews: [
                                                        createStackView(stackView: firstStackView),
                                                        createStackView(stackView: twoStackView),
                                                        createStackView(stackView: thirdStackView),
                                                        createStackView(stackView: fourStackView)
                                                    ])
    private var buttonTypes: [ButtonType] = []
    private var buttons: [UIButton] = []
    private var userCode: [Int] = []
    private var rightCode: [Int] = [1, 2, 3, 4, 5]
    private let dotesNumber = 5

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

    // MARK: - Actions

    @objc private func numberButtonAction(sender: UIButton) {
        if userCode.count < dotesNumber {
            guard let index = buttons.firstIndex(of: sender) else { return }
            userCode.append(index)
            for item in 0..<userCode.count {
                dotes[item].background(.blue())
            }
        }
        if userCode.count == dotesNumber {
            for x in 0..<userCode.count where userCode[x] != rightCode[x] {
                for item in 0..<userCode.count {
                    dotes[item].background(.red())
                }
            }
        }
    }

    @objc private func deleteButtonAction(sender: UIButton) {
        if !userCode.isEmpty {
            userCode.removeLast()
        }
        for item in dotes {
            item.background(.lightBlue())
        }
        for item in 0..<userCode.count {
            dotes[item].background(.blue())
        }
    }

    // MARK: - Private Methods

    private func createButtons() {
        buttons.append(createButton(.number(0)))
        (1...9).forEach { number in
            buttons.append(createButton(.number(number)))
        }
        buttons.append(createButton(.faceId))
        buttons.append(createButton(.delete))
    }

    private func createButton(_ type: ButtonType) -> UIButton {
        buttonTypes.append(type)

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 0.98
        paragraphStyle.alignment = .center

        let button = UIButton()
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
            button.background(.paleBlue())
            button.addTarget(self, action: #selector(numberButtonAction), for: .touchUpInside)
        case .faceId:
            button.setImage(R.image.pinCode.faceId(), for: .normal)
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
            let view = UIImageView()
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
