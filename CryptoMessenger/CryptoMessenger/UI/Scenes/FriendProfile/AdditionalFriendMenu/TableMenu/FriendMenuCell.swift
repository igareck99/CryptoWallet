import UIKit

// MARK: - MenuCell

final class MenuFriendCell: UITableViewCell {

    // MARK: - Private Properties

    private lazy var menuLabel = UILabel()
    private lazy var menuImage = UIImageView()

    // MARK: - Lifecycle

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addMenuImage()
        addMenuLabel()
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("not implemented")
    }

    // MARK: - Internal Methods

    func configure(_ profile: MenuFriendItem) {
        menuImage.image = profile.image
        menuLabel.text = profile.text
        if menuLabel.text == R.string.localizable.friendProfileComplain() ||
            menuLabel.text == R.string.localizable.friendProfileBlock() {
            menuLabel.textColor(.lightRed())
            menuImage.background(.lightRed(0.1))
        } else {
            menuLabel.textColor(.blue())
            menuImage.background(.lightBlue())
        }
    }

    // MARK: - Private Methods

    private func addMenuImage() {
        menuImage.snap(parent: self) {
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
            $0.font(.light(17))
        } layout: {
            $0.leading.equalTo($1).offset(72)
            $0.top.equalTo($1).offset(21)
        }
    }
}
