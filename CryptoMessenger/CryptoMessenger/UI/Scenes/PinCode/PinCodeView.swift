import UIKit

// MARK: - PinCodeView

final class PinCodeView: UIView {

    // MARK: - Internal Properties

    var didTap: (() -> Void)?

    // MARK: - Private Properties

    private lazy var auraLabel = UIButton()
    private lazy var passwordLabel = UILabel()
    private lazy var EnterLabel = UILabel()
    private lazy var firstStackView = UIStackView(arrangedSubviews: [buttonsArray[0], buttonsArray[1], buttonsArray[2]])
    private lazy var twoStackView = UIStackView(arrangedSubviews: [buttonsArray[3], buttonsArray[4], buttonsArray[5]])
    private lazy var thirdStackView = UIStackView(arrangedSubviews: [buttonsArray[6], buttonsArray[7], buttonsArray[8]])
    private lazy var fourStackView = UIStackView(arrangedSubviews: [buttonsArray[9], buttonsArray[10], buttonsArray[11]])
    private lazy var dotes: [UIButton] = []
    private lazy var dotesStackView = UIStackView()
    private lazy var unionStackView = UIStackView(arrangedSubviews: [
                                                    settingsStackView(stackView: firstStackView),
                                                    settingsStackView(stackView: twoStackView),
                                                    settingsStackView(stackView: thirdStackView),
                                                    settingsStackView(stackView: fourStackView)])
    private lazy var buttonsArray : [UIButton] = [
        createButton(image: R.image.pinCode.backgroundbutton(), text: "1"),
        createButton(image: R.image.pinCode.backgroundbutton(), text: "2"),
        createButton(image: R.image.pinCode.backgroundbutton(), text: "3"),
        createButton(image: R.image.pinCode.backgroundbutton(), text: "4"),
        createButton(image: R.image.pinCode.backgroundbutton(), text: "5"),
        createButton(image: R.image.pinCode.backgroundbutton(), text: "6"),
        createButton(image: R.image.pinCode.backgroundbutton(), text: "7"),
        createButton(image: R.image.pinCode.backgroundbutton(), text: "8"),
        createButton(image: R.image.pinCode.backgroundbutton(), text: "9"),
        createButton(image: R.image.pinCode.faceId()),
        createButton(image: R.image.pinCode.backgroundbutton(), text: "0"),
        createButton(image: R.image.pinCode.delete())
    ]
    // MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        background(.white())
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

    private func createButton(image: UIImage!, text: String = "") -> UIButton {
        let button = UIButton()
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.15
        paragraphStyle.alignment = .center
        if text.isEmpty == false {
            button.titleAttributes(text: text,
                                   [
                                    .font(.medium(24)),
                                    .color(.black()),
                                    .paragraph(paragraphStyle)
                                   ]
            )
        }
        button.setTitle(text, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.imageView?.contentMode = .scaleAspectFit
        button.frame.size = CGSize(width: 67, height: 67)
        button.setBackgroundImage(image, for: .normal)
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
