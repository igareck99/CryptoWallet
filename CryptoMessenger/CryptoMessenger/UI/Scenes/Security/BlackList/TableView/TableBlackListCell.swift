import UIKit

// MARK: - UsersBlackCell

class TableBlackListCell: UITableViewCell {

    // MARK: - Private Properties

    private lazy var nameLabel = UILabel()
    private lazy var statusLabel = UILabel()
    private lazy var profileImageView = UIImageView()

    // MARK: - Lifecycle

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addProfileImage()
        addNameLabel()
        addStatusLabel()
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("not implemented")
    }

    // MARK: - Internal Methods

    func configure(_ profile: BlackListItem) {
        nameLabel.text = profile.name
        statusLabel.text = profile.status
        profileImageView.image = profile.image
    }

    // MARK: - Private Methods

    private func addProfileImage() {
        profileImageView.snap(parent: self) {
            $0.contentMode = .scaleAspectFill
            $0.clipsToBounds = true
            $0.clipCorners(radius: 20)
        } layout: {
            $0.width.height.equalTo(40)
            $0.leading.equalTo($1).offset(16)
            $0.top.equalTo($1).offset(16)
        }
    }

    private func addNameLabel() {
        nameLabel.snap(parent: self) {
            $0.font(.medium(15))
            $0.textColor(.black())
        } layout: {
            $0.height.equalTo(21)
            $0.leading.equalTo($1).offset(68)
            $0.top.equalTo($1).offset(13)
        }
    }

    private func addStatusLabel() {
        statusLabel.snap(parent: self) {
            $0.font(.light(13))
            $0.textColor(.gray())
        } layout: {
            $0.leading.equalTo($1).offset(68)
            $0.top.equalTo(self.nameLabel.snp.bottom).offset(4)
        }
    }
}
