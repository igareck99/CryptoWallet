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

    private lazy var auraLabel = UIButton()
    private lazy var passwordLabel = UILabel()
    private lazy var EnterLabel = UILabel()
    private lazy var firstStackView = UIStackView(arrangedSubviews: [buttons[0], buttons[1], buttons[2]])
    private lazy var twoStackView = UIStackView(arrangedSubviews: [buttons[3], buttons[4], buttons[5]])
    private lazy var thirdStackView = UIStackView(arrangedSubviews: [buttons[6], buttons[7], buttons[8]])
    private lazy var fourStackView = UIStackView(arrangedSubviews: [buttons[9], buttons[10], buttons[11]])
    private lazy var dotes: [UIView] = []
    private lazy var dotesStackView = UIStackView()
    private lazy var unionStackView = UIStackView(arrangedSubviews: [
                                                    settingsStackView(stackView: firstStackView),
                                                    settingsStackView(stackView: twoStackView),
                                                    settingsStackView(stackView: thirdStackView),
                                                    settingsStackView(stackView: fourStackView)])
    private var buttonTypes: [ButtonType] = []
    private var buttons: [UIButton] = []

    // MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        background(.white())
        createButtons()
        addauraLabel()
        addPasswordLabel()
        addDotes()
        addUnionStack()
        addcantEnterLabel()
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("not implemented")
    }

    // MARK: - Internal Methods

    func internalMethod() {

    }

    // MARK: - Private Methods

    private func createButtons() {
        (1...9).forEach { number in
            buttons.append(createButton(.number(number)))
        }

        buttons.append(createButton(.faceId))
        buttons.append(createButton(.number(0)))
        buttons.append(createButton(.delete))
    }

    private func createButton(_ type: ButtonType) -> UIButton {
        buttonTypes.append(type)

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 0.98
        paragraphStyle.alignment = .center

        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 67, height: 67))
        button.translatesAutoresizingMaskIntoConstraints = false

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
            button.clipCorners(radius: button.frame.height * 0.5)
        case .faceId:
            button.setImage(R.image.pinCode.faceId(), for: .normal)
        case .delete:
            button.setImage(R.image.pinCode.delete(), for: .normal)
        }

        return button
    }

    private func settingsStackView(stackView: UIStackView) -> UIStackView {
        stackView.axis = NSLayoutConstraint.Axis.horizontal
        stackView.spacing = 33
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }

    private func addauraLabel() {
        auraLabel.snap(parent: self) {
            $0.setImage(R.image.pinCode.aura(), for: .normal)
            $0.imageView?.contentMode = .scaleAspectFill
        } layout: {
            $0.top.equalTo(self.snp_topMargin).offset(66.82)
            $0.width.height.equalTo(58.38)
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
            $0.top.equalTo(self.auraLabel.snp.bottom).offset(32.8)
            $0.centerX.equalTo($1)
        }
    }

    private func addUnionStack() {
        unionStackView.snap(parent: self) {
            $0.axis = NSLayoutConstraint.Axis.vertical
            $0.spacing = 25
            $0.distribution = .fillEqually
            $0.alignment = .fill
            $0.translatesAutoresizingMaskIntoConstraints = false
        } layout: {
            $0.leading.equalTo($1).offset(54)
            $0.trailing.equalTo($1).offset(-54)
            $0.top.equalTo(self.dotesStackView.snp.bottom).offset(60)
        }
    }

    private func addDotes() {
        (0..<5).forEach { _ in
            let label = UIButton()
            label.setImage(R.image.pinCode.waitdote(), for: .normal)
            label.snp.makeConstraints {
                $0.width.height.equalTo(14)
            }
            dotes.append(label)
            dotesStackView.addArrangedSubview(label)
        }
            dotesStackView.snap(parent: self) {
                $0.alignment = .fill
                $0.axis = .horizontal
                $0.spacing = 16
            } layout: {
                $0.top.equalTo(self.passwordLabel.snp.bottom).offset(32)
                $0.centerX.equalTo($1)
                $0.height.equalTo(25)
            }
        }

    private func addcantEnterLabel() {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.15
        paragraphStyle.alignment = .center
        EnterLabel.snap(parent: self) {
            $0.titleAttributes(
                text: R.string.localizable.pinCodeEnter(),
                [
                    .paragraph(paragraphStyle),
                    .font(.medium(15)),
                    .color(.blue())
                ]
            )
            $0.textAlignment = .center
        } layout: {
            $0.centerX.equalTo($1)
            $0.bottom.equalTo(self.unionStackView.snp.bottom).offset(80)
        }
    }
}
