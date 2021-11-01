import UIKit

// MARK: - MenuCell

final class MenuCell: UITableViewCell {

    // MARK: - Internal Properties

    var didTap: VoidBlock?

    // MARK: - Private Properties

    private lazy var menuLabel = UILabel()
    private lazy var menuImage = UIImageView()
    private lazy var notificationsLabel = UILabel()
    private lazy var arrowImageView = UIImageView()
    private lazy var tapButton = UIButton()

    // MARK: - Lifecycle

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addMenuImage()
        addMenuLabel()
        addNotificationsLabel()
        addArrowImageView()
        addTapButton()
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("not implemented")
    }

    // MARK: - Internal Methods

    func configure(_ profile: MenuItem) {
        menuImage.image = profile.image
        menuLabel.text = profile.text
        if profile.notifications != 0 {
            notificationsLabel.text = String(profile.notifications)
            notificationsLabel.background(.lightRed())
        } else {
            notificationsLabel.text = ""
            notificationsLabel.background(.clear)
        }
    }

    // MARK: - Actions

    @objc private func didTapOpen() {
        didTap?()
    }

    // MARK: - Private Methods

    private func addMenuImage() {
        menuImage.snap(parent: contentView) {
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
        menuLabel.snap(parent: contentView) {
            $0.font(.light(16))
            $0.textColor(.black())
        } layout: {
            $0.leading.equalTo($1).offset(72)
            $0.top.equalTo($1).offset(23)
        }
    }

    private func addNotificationsLabel() {
        notificationsLabel.snap(parent: contentView) {
            $0.textColor(.white())
            $0.font(.light(13))
            $0.textAlignment = .center
            $0.clipCorners(radius: 10)
        } layout: {
            $0.width.height.equalTo(20)
            $0.trailing.equalTo($1).offset(-46)
            $0.top.equalTo($1).offset(23)
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

    private func addTapButton() {
        tapButton.snap(parent: contentView) {
            $0.addTarget(self, action: #selector(self.didTapOpen), for: .touchUpInside)
        } layout: {
            $0.top.leading.trailing.bottom.equalTo($1)
        }
    }
}
