import UIKit

// MARK: - ProfileBackgroundHeaderView

final class ProfileBackgroundHeaderView: UICollectionReusableView {

    // MARK: - Internal Properties

    var didTap: VoidBlock?
    static let identifier = "HeaderBackgroundReusableView"

    // MARK: - Private Properties

    private lazy var galleryImage = UIImageView()
    private lazy var mainLabel = UILabel()
    private lazy var selectedImageView = UIImageView()
    private lazy var wallpaperLabel = UILabel()
    private lazy var tapButton = UIButton()

    // MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        addTapButton()
        addGalleryImage()
        addMainLabel()
        addArrowImageView()
        addWallpaperLabel()
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("not implemented")
    }

    // MARK: - Internal Methods

    func configure(_ profile: ProfileBackgroundItem) {
        mainLabel.text = profile.text
    }

    @objc private func tapAction() {
        didTap?()
    }

    // MARK: - Private Methods

    private func addGalleryImage() {
        galleryImage.snap(parent: self) {
            $0.background(.lightBlue())
            $0.image = R.image.profileBackground.gallery()
            $0.clipsToBounds = true
            $0.contentMode = .center
            $0.clipCorners(radius: 20)
        } layout: {
            $0.width.height.equalTo(40)
            $0.leading.equalTo($1)
            $0.centerY.equalTo($1)
        }
    }

    private func addMainLabel() {
        mainLabel.snap(parent: self) {
            $0.font(.light(17))
            $0.textColor(.blue())
        } layout: {
            $0.height.equalTo(21)
            $0.leading.equalTo($1).offset(64)
            $0.centerY.equalTo($1)
        }
    }

    private func addArrowImageView() {
        selectedImageView.snap(parent: self) {
            $0.contentMode = .center
            $0.image = R.image.additionalMenu.grayArrow()
        } layout: {
            $0.width.height.equalTo(24)
            $0.trailing.equalTo($1).offset(-4)
            $0.centerY.equalTo($1)
        }
    }

    private func addWallpaperLabel() {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.22
        paragraphStyle.alignment = .left

        wallpaperLabel.snap(parent: self) {
            $0.titleAttributes(
                text: R.string.localizable.profileBackgroundWallpaper(),
                [
                    .paragraph(paragraphStyle),
                    .font(.regular(12)),
                    .color(.darkGray())
                ]
            )
            $0.textAlignment = .left
            $0.numberOfLines = 0
        } layout: {
            $0.top.equalTo(self.galleryImage.snp.bottom).offset(8)
            $0.leading.equalTo($1)
            $0.height.equalTo(22)
        }
    }

    private func addTapButton() {
        tapButton.snap(parent: self) {
            $0.background(.white())
            $0.addTarget(self, action: #selector(self.tapAction), for: .touchUpInside)
        } layout: {
            $0.height.equalTo(64)
            $0.top.equalTo($1)
            $0.leading.equalTo($1)
            $0.trailing.equalTo($1)
        }
    }
}
