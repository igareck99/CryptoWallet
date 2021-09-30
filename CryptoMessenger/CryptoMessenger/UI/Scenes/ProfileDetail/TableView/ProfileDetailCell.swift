import UIKit

// MARK: - ProfileDetailCell

final class ProfileDetailCell: UITableViewCell {

    // MARK: - Internal Properties

    weak var delegate: ProfileDetailView?

    // MARK: - Private Properties

    private lazy var cellLabel = UILabel()
    private lazy var cellImage = UIImageView()
    private lazy var cellType = Int()
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

    func configure(_ profile: ProfileDetailItem) {
        cellImage.image = profile.image
        cellLabel.text = profile.text
        if profile.type == 0 {
            cellImage.background(.lightBlue())
            openButton.isHidden = false
        } else {
            cellImage.background(.lightRed(0.1))
            openButton.isHidden = true
        }
    }

    // MARK: - Private Methods

    private func addMenuImage() {
        cellImage.snap(parent: self) {
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
        cellLabel.snap(parent: self) {
            $0.font(.light(16))
            $0.textColor(.black())
        } layout: {
            $0.leading.equalTo($1).offset(72)
            $0.top.equalTo($1).offset(23)
        }
    }

    private func addOpenButton() {
        openButton.snap(parent: self) {
            $0.contentMode = .center
            $0.setImage(R.image.additionalMenu.grayArrow(), for: .normal)
        } layout: {
            $0.width.equalTo(24)
            $0.height.equalTo(24)
            $0.trailing.equalTo($1).offset(-23)
            $0.top.equalTo($1).offset(22)
        }
    }
}
