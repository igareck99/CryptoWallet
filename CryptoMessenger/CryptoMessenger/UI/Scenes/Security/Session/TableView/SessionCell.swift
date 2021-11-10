import UIKit

// MARK: - SessionCell

class SessionCell: UITableViewCell {

    // MARK: - Private Properties

    private lazy var deviceImage = UIImageView()
    private lazy var titleLabel = UILabel()
    private lazy var datePlaceLabel = UILabel()
    private lazy var arrowImageView = UIImageView()

    // MARK: - Lifecycle

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addDeviceImageView()
        addTitleLabel()
        addDatePlaceLabel()
        addArrowImageView()
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("not implemented")
    }

    // MARK: - Internal Methods

    func configure(_ profile: SessionItem) {
        datePlaceLabel.text = profile.time + " • " + profile.place
        switch profile.device {
        case .iphone:
            titleLabel.text = "IPhone" + ", " + profile.loginMethod
            deviceImage.image = R.image.session.iphone()
        case .android:
            titleLabel.text = "Andoid" + ", " + profile.loginMethod
            deviceImage.image = R.image.session.android()
        }
    }

    // MARK: - Private Methods

    private func addDeviceImageView() {
        deviceImage.snap(parent: contentView) {
            $0.contentMode = .center
        } layout: {
            $0.width.height.equalTo(40)
            $0.leading.equalTo($1).offset(16)
            $0.top.equalTo($1).offset(12)
        }
    }

    private func addTitleLabel() {
        titleLabel.snap(parent: self) {
            $0.font(.regular(15))
            $0.textColor(.black())
        } layout: {
            $0.leading.equalTo($1).offset(72)
            $0.top.equalTo($1).offset(11)
            $0.height.equalTo(21)
        }
    }

    private func addDatePlaceLabel() {
        datePlaceLabel.snap(parent: contentView) {
            $0.textColor(.gray())
            $0.font(.light(12))
            $0.textAlignment = .left
        } layout: {
            $0.top.equalTo(self.titleLabel.snp.bottom).offset(2)
            $0.leading.equalTo($1).offset(72)
            $0.height.equalTo(16)
        }
    }

    private func addArrowImageView() {
        arrowImageView.snap(parent: contentView) {
            $0.contentMode = .center
            $0.image = R.image.additionalMenu.grayArrow()
        } layout: {
            $0.width.equalTo(7)
            $0.height.equalTo(12)
            $0.trailing.equalTo($1).offset(-24)
            $0.top.equalTo($1).offset(26)
        }
    }
}
