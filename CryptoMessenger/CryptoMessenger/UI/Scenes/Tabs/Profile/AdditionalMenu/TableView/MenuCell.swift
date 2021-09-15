import UIKit

// MARK: - MenuCell

class MenuCell: UITableViewCell {

    // MARK: - Internal Properties

    weak var delegate: AdditionalMenuView?

    // MARK: - Private Properties

    private lazy var menuLabel = UILabel()
    private lazy var menuImage = UIImageView()
    private lazy var notificationsLabel = UILabel()
    private lazy var openButton = UIButton()
    private lazy var notificationsAmount = 1

    // MARK: - Lifecycle

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addMenuImage()
        addMenuLabel()
        addNotificationsLabel()
        addOpenButton()

    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("not implemented")
    }

    // MARK: - Internal Methods

    func configure(_ profile: MenuItem) {
        menuImage.image = profile.image
        menuLabel.text = profile.text
        if profile.Notifications != 0 {
            notificationsLabel.text = String(profile.Notifications)
            notificationsLabel.background(.lightRed())
        } else {
            notificationsLabel.text = ""
            notificationsLabel.background(.clear)
        }
    }

    // MARK: - Private Methods

    private func addMenuImage() {
        menuImage.snap(parent: self) {
            $0.background(.lightBlue())
            $0.clipsToBounds = true
            $0.contentMode = .center
            $0.clipCorners(radius: 20)
        } layout: {
            $0.width.height.equalTo(40)
            $0.leading.equalTo($1).offset(16)
            $0.centerY.equalTo($1)
        }
    }

    private func addMenuLabel() {
        menuLabel.snap(parent: self) {
            $0.font(.light(16))
            $0.textColor(.black())
        } layout: {
            $0.leading.equalTo($1).offset(72)
            $0.top.equalTo($1).offset(23)
        }
    }

    private func addNotificationsLabel() {
        notificationsLabel.snap(parent: self) {
            $0.textColor(.white())
            $0.font(.light(13))
            $0.textAlignment = .center
            $0.clipsToBounds = true
            $0.clipCorners(radius: 10)
        } layout: {
            $0.width.height.equalTo(20)
            $0.trailing.equalTo($1).offset(-46)
            $0.top.equalTo($1).offset(23)
        }
    }

    private func addOpenButton() {
        openButton.snap(parent: self) {
            $0.contentMode = .center
            $0.clipsToBounds = true
            $0.setImage(R.image.additionalMenu.grayArrow(), for: .normal)
        } layout: {
            $0.width.equalTo(24)
            $0.height.equalTo(24)
            $0.trailing.equalTo($1).offset(-23)
            $0.top.equalTo($1).offset(22)
        }
    }
}
