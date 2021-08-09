import UIKit

// MARK: - PinCodeView

final class PinCodeView: UIView {

    // MARK: - Internal Properties

    var didTap: (() -> Void)?

    // MARK: - Private Properties

    private lazy var auraLabel = UIButton()
    private lazy var passwordLabel = UILabel()
    private lazy var EnterLabel = UILabel()
    private lazy var buttonsArray : [UIButton] = []
    private lazy var firstStackView = UIStackView()

    // MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        background(.white())
        initButtons()
        addauraLabel()
        addPasswordLabel()
        createFirstStack()
        addcantEnterLabel()
        createFirstStack()
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
        if text.isEmpty == false {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineHeightMultiple = 1.15
            paragraphStyle.alignment = .center
            button.titleAttributes(text: text, [
                .font(.medium(24)),
                .color(.black())
            ])
        }
        button.setImage(image, for: .normal)
        print(button.imageView!.image)
        return button

    }

    private func initButtons() {
        buttonsArray = [
            createButton(image: R.image.pinCode.backgroundbutton(), text: "1"),
            createButton(image: R.image.pinCode.backgroundbutton(), text: "2"),
            createButton(image: R.image.pinCode.backgroundbutton(), text: "3"),
            createButton(image: R.image.pinCode.backgroundbutton(), text: "4"),
            createButton(image: R.image.pinCode.backgroundbutton(), text: "5"),
            createButton(image: R.image.pinCode.backgroundbutton(), text: "6"),
            createButton(image: R.image.pinCode.backgroundbutton(), text: "7"),
            createButton(image: R.image.pinCode.backgroundbutton(), text: "8"),
            createButton(image: R.image.pinCode.backgroundbutton(), text: "9"),
            createButton(image: R.image.pinCode.faceid()),
            createButton(image: R.image.pinCode.backgroundbutton(), text: "0"),
            createButton(image: R.image.pinCode.delete())
        ]
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

    private func createFirstStack() {
        firstStackView.addSubview(buttonsArray[0])
        firstStackView.addSubview(buttonsArray[1])
        firstStackView.addSubview(buttonsArray[2])
        firstStackView.snap(parent: self) {
            $0.axis = NSLayoutConstraint.Axis.horizontal
            $0.spacing = 33
            $0.distribution = .fillEqually
            $0.alignment = .fill
            $0.translatesAutoresizingMaskIntoConstraints = false
        } layout: {
            $0.leading.trailing.equalTo($1).offset(54)
            $0.top.equalTo(self.passwordLabel.snp.bottom).offset(106)
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
            $0.bottom.equalTo(self.snp_bottomMargin).offset(40.14)
        }
    }
}
