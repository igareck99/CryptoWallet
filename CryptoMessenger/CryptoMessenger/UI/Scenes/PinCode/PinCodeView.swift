import UIKit

// MARK: - PinCodeView

final class PinCodeView: UIView {

    // MARK: - Internal Properties

    var didTap: (() -> Void)?

    // MARK: - Private Properties

    private lazy var auraLabel = UIButton()
    private lazy var passwordLabel = UILabel()
    private lazy var zeroButton = UIButton()
    private lazy var oneButton = UIButton()
    private lazy var twoButton = UIButton()
    private lazy var threeButton = UIButton()
    private lazy var fourButton = UIButton()
    private lazy var fiveButton = UIButton()
    private lazy var sixButton = UIButton()
    private lazy var sevenButton = UIButton()
    private lazy var eightButton = UIButton()
    private lazy var nineButton = UIButton()
    private lazy var faceidButton = UIButton()
    private lazy var deleteNumberButton = UIButton()
    private lazy var EnterLabel = UILabel()
    private lazy var stackView = UIStackView()

    // MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        background(.white())
        addauraLabel()
        addPasswordLabel()
        createFirstStack()
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
        twoButton.setImage(R.image.pinCode.backgroundbutton(), for: .normal)
        threeButton.setImage(R.image.pinCode.backgroundbutton(), for: .normal)
        stackView.addSubview(oneButton)
        stackView.addSubview(twoButton)
        threeButton.translatesAutoresizingMaskIntoConstraints = false
        threeButton.titleAttributes(text: "3", [
            .font(.medium(24)),
            .color(.black())
        ])
        oneButton.snap(parent: self) {
            $0.setImage(R.image.pinCode.backgroundbutton(), for: .normal)
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.contentMode = .scaleAspectFit
            $0.titleLabel?.textAlignment = .center
            $0.titleAttributes(text: "1", [
                .font(.medium(24)),
                .color(.black())
            ])

        } layout: {
            $0.width.height.equalTo(67)
            $0.leading.equalTo($1).offset(0)
            $0.trailing.equalTo($1).offset(33)
        }
        twoButton.snap(parent: self) {
            $0.setImage(R.image.pinCode.backgroundbutton(), for: .normal)
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.contentMode = .scaleAspectFit
            $0.titleAttributes(text: "2", [
                .font(.medium(24)),
                .color(.black())
            ])
        } layout: {
            $0.leading.equalTo($1).offset(33)
        }
        stackView.snap(parent: self) {
            $0.axis = NSLayoutConstraint.Axis.horizontal
            $0.spacing = 33
            $0.distribution = .fillEqually
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
