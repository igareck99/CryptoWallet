import UIKit

// MARK: - MenuCell

class MenuCell: UITableViewCell {

    // MARK: - Private Properties

    private lazy var menuLabel = UILabel()
    private lazy var menuImage = UIImageView()
    private lazy var notificationsImage = UIImageView()
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
        if profile.isNotifications {
            notificationsImage.image = R.image.additionalMenu.grayArrow()
        }
    }

    // MARK: - Private Methods

    private func addMenuImage() {
        menuImage.snap(parent: self) {
            $0.background(.white())
            $0.contentMode = .scaleAspectFill
            $0.clipsToBounds = true
            $0.clipCorners(radius: 20)
        } layout: {
            $0.width.height.equalTo(24)
            $0.leading.equalTo($1).offset(16)
            $0.centerY.equalTo($1)
        }
    }

    private func addMenuLabel() {
        menuLabel.snap(parent: self) {
            $0.font(.medium(15))
            $0.textColor(.black())
        } layout: {
            $0.leading.equalTo($1).offset(72)
            $0.top.equalTo($1).offset(23)
        }
    }

    private func addOpenButton() {
        openButton.snap(parent: self) {
            $0.contentMode = .scaleAspectFill
            $0.clipsToBounds = true
        } layout: {
            $0.width.equalTo(7)
            $0.height.equalTo(12)
            $0.leading.equalTo($1).offset(344)
            $0.top.equalTo($1).offset(28)
        }
    }
}
