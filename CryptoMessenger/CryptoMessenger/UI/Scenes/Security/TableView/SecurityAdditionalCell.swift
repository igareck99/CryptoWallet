import UIKit

// MARK: - SecurityAdditionalCell

class SecurityAdditionalCell: UITableViewCell {

    // MARK: - Internal Properties

    var didSwitchTap: VoidBlock?
    var didFalseTap: VoidBlock?
    var didAuthTap: VoidBlock?

    // MARK: - Private Properties

    private lazy var titleLabel = UILabel()
    private lazy var descriptionLabel = UILabel()
    private lazy var arrowImageView = UIImageView()
    private lazy var slider = UISwitch()

    @Injectable private var userFlows: UserFlowsStorageService
    @Injectable private var userCredentials: UserCredentialsStorageService

    // MARK: - Lifecycle

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addTitleLabel()
        addDescriptionLabel()
        addSlider()
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("not implemented")
    }

    // MARK: - Internal Methods

    @objc private func pinCodeOn() {
        if slider.isOn {
            didFalseTap?()
            didAuthTap?()
        } else {
            userFlows.isFalsePinCodeOn = false
            userFlows.isPinCodeOn = false
            userCredentials.userPinCode = ""
            userCredentials.userFalsePinCode = ""
        }
    }

    func configure(_ profile: SecurityItem) {
        titleLabel.text = profile.title
        descriptionLabel.text = profile.currentState
        if profile.title == "Вход по опечатку/ face ID" {
            slider.isOn = userFlows.isLocalAuth
        } else {
            slider.isOn = userFlows.isFalsePinCodeOn
            userCredentials.userFalsePinCode = ""
            falsePasswordCalled = false
        }
    }

    // MARK: - Private Methods

    private func addTitleLabel() {
        titleLabel.snap(parent: self) {
            $0.font(.regular(15))
            $0.textColor(.black())
        } layout: {
            $0.leading.equalTo($1).offset(16)
            $0.top.equalTo($1).offset(21)
            $0.height.equalTo(21)
        }
    }

    private func addDescriptionLabel() {
        descriptionLabel.snap(parent: self) {
            $0.textColor(.gray())
            $0.font(.light(15))
            $0.textAlignment = .left
        } layout: {
            $0.top.equalTo(self.titleLabel.snp.bottom).offset(4)
            $0.leading.equalTo($1).offset(16)
            $0.height.equalTo(16)
        }
    }

    private func addSlider() {
        slider.snap(parent: contentView) {
            $0.contentMode = .center
            $0.onTintColor(.blue())
            $0.addTarget(self, action: #selector(self.pinCodeOn), for: .touchUpInside)
        } layout: {
            $0.trailing.equalTo($1).offset(-23)
            $0.top.equalTo($1).offset(18)
        }
    }
}
