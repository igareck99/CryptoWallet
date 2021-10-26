import UIKit

// MARK: - ProfileBackgroundCell

final class ProfileBackgroundCell: UITableViewCell {

    // MARK: - Internal Properties

    var didTap: VoidBlock?

    // MARK: - Private Properties

    private lazy var galleryImage = UIImageView()
    private lazy var mainLabel = UILabel()
    private lazy var selectedImageView = UIImageView()

    // MARK: - Lifecycle

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addGalleryImage()
        addMainLabel()
        addArrowImageView()
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("not implemented")
    }

    // MARK: - Internal Methods

    func configure(_ profile: ProfileBackgroundItem) {
        mainLabel.text = profile.text
    }

    // MARK: - Private Methods

    private func addGalleryImage() {
        galleryImage.snap(parent: contentView) {
            $0.background(.lightBlue())
            $0.image = R.image.profileBackground.gallery()
            $0.clipsToBounds = true
            $0.contentMode = .center
            $0.clipCorners(radius: 20)
        } layout: {
            $0.width.height.equalTo(40)
            $0.leading.equalTo($1).offset(16)
            $0.centerY.equalTo($1)
        }
    }

    private func addMainLabel() {
        mainLabel.snap(parent: contentView) {
            $0.font(.light(17))
            $0.textColor(.blue())
        } layout: {
            $0.height.equalTo(21)
            $0.leading.equalTo($1).offset(72)
            $0.centerY.equalTo($1)
        }
    }

    private func addArrowImageView() {
        selectedImageView.snap(parent: contentView) {
            $0.contentMode = .center
            $0.image = R.image.additionalMenu.grayArrow()
        } layout: {
            $0.width.height.equalTo(24)
            $0.trailing.equalTo($1).offset(-16)
            $0.centerY.equalTo($1)
        }
    }

}
