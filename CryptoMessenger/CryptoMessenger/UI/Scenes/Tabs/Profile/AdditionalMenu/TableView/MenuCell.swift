import UIKit

// MARK: - MenuCell

class MenuCell: UITableViewCell {

    // MARK: - Private Properties

    private lazy var menuLabel = UILabel()
    private lazy var menuImage = UIImageView()
    private lazy var notificationsImage = UIImageView()
    private lazy var notificationsAmount = 0
    private lazy var openButton = UIButton()

    // MARK: - Lifecycle

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addMenuImage()
        addMenuLabel()
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
        notificationsAmount = profile.Notifications
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

    private func addNotificationsView() {
        if notificationsAmount != 0 {
            notificationsImage.snap(parent: self) {
                let label = UILabel()
                label.titleAttributes(
                    text: String(self.notificationsAmount),
                    [
                        .color(.white()),
                        .font(.light(13))
                    ]
                )
                $0.image = UIImage(label)
                $0.contentMode = .scaleAspectFill
                $0.clipsToBounds = true
                $0.clipCorners(radius: 10)
                $0.background(.lightRed())
            } layout: {
                $0.width.height.equalTo(20)
                $0.trailing.equalTo($1).offset(40)
                $0.top.equalTo($1).offset(28)
            }
        } else {
            return
        }
    }

    private func addOpenButton() {
        openButton.snap(parent: self) {
            $0.contentMode = .scaleAspectFill
            $0.clipsToBounds = true
            $0.setImage(R.image.additionalMenu.grayArrow(), for: .normal)
        } layout: {
            $0.width.equalTo(7)
            $0.height.equalTo(12)
            $0.trailing.equalTo($1).offset(-23)
            $0.top.equalTo($1).offset(28)
        }
    }
}
