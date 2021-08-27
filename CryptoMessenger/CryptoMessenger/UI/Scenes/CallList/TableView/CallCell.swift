import UIKit

// MARK: - CallCell

class CallCell: UITableViewCell {

    // MARK: - Private Properties

    private lazy var nameLabel = UILabel()
    private lazy var dateLabel = UILabel()
    private lazy var profileImageView = UIImageView()
    private lazy var phoneButton = UIButton()
    private lazy var сallTypeImageView = UIImageView()

    // MARK: - Lifecycle

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addProfileImage()
        addNameLabel()
        addСallTypeImageView()
        addDateLabel()
        addPhoneButton()
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("not implemented")
    }

    // MARK: - Internal Methods

    func configure(_ profile: CallItem) {
        nameLabel.text = profile.name
        dateLabel.text = profile.dateTime
        profileImageView.image = profile.image
        if profile.isIncall {
            сallTypeImageView.image = R.image.callList.incall()
        } else {
            сallTypeImageView.image = R.image.callList.outcall()
        }
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
            $0.centerY.equalTo($1)
        }
    }

    private func addNameLabel() {
        nameLabel.snap(parent: self) {
            $0.font(.medium(15))
            $0.textColor(.black())
        } layout: {
            $0.leading.equalTo($1).offset(68)
            $0.top.equalTo($1).offset(17)
        }
    }

    private func addСallTypeImageView() {
        сallTypeImageView.snap(parent: self) {
            $0.contentMode = .scaleAspectFill
            $0.clipsToBounds = true
        } layout: {
            $0.width.height.equalTo(8.5)
            $0.leading.equalTo($1).offset(70)
            $0.top.equalTo(self.nameLabel.snp.bottom).offset(8)
        }
    }

    private func addDateLabel() {
        dateLabel.snap(parent: self) {
            $0.font(.light(13))
            $0.textColor(.black())
        } layout: {
            $0.leading.equalTo($1).offset(84)
            $0.top.equalTo(self.nameLabel.snp.bottom).offset(4)
        }
    }

    private func addPhoneButton() {
        phoneButton.snap(parent: self) {
            $0.contentMode = .scaleAspectFill
            $0.setImage(R.image.callList.bluePhone(), for: .normal)
        } layout: {
            $0.width.height.equalTo(24)
            $0.leading.equalTo($1).offset(339)
            $0.top.equalTo($1).offset(25)
        }
    }
}
