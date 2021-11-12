import UIKit

// MARK: - SecurityCell

class SecurityCell: UITableViewCell {

    // MARK: - Internal Properties

    var didSwitchTap: VoidBlock?

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
        addSlider()
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("not implemented")
    }

    // MARK: - Internal Methods

    @objc private func pinCodeOn() {
        userFlows.isPinCodeOn = slider.isOn
        if userFlows.isPinCodeOn {

        } else {
            userCredentials.userPinCode = ""
        }
        didSwitchTap?()
    }

    func configure(_ profile: SecurityItem) {
        titleLabel.text = profile.title
        descriptionLabel.text = profile.currentState
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
        descriptionLabel.snap(parent: contentView) {
            $0.textColor(.gray())
            $0.font(.light(15))
            $0.textAlignment = .left
        } layout: {
            $0.top.equalTo($1).offset(21)
            $0.trailing.equalTo($1).offset(-48)
            $0.height.equalTo(21)
        }
    }

    private func addArrowImageView() {
        arrowImageView.snap(parent: contentView) {
            $0.contentMode = .center
            $0.image = R.image.additionalMenu.grayArrow()
        } layout: {
            $0.width.height.equalTo(24)
            $0.trailing.equalTo($1).offset(-23)
            $0.top.equalTo($1).offset(22)
        }
    }

    private func addSlider() {
        slider.snap(parent: contentView) {
            $0.isOn = !self.userCredentials.userPinCode.isEmpty
            $0.contentMode = .center
            $0.onTintColor(.blue())
            $0.addTarget(self, action: #selector(self.pinCodeOn), for: .touchUpInside)
        } layout: {
            $0.trailing.equalTo($1).offset(-23)
            $0.top.equalTo($1).offset(18)
        }
    }
}
