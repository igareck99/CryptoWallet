import UIKit

// MARK: - ProfileBackgroundPreviewView

final class ProfileBackgroundPreviewView: UIView {

    // MARK: - Internal Properties

    var didTap: (() -> Void)?

    // MARK: - Private Properties

    private lazy var titleLabel = UILabel()
    private lazy var profileImage = UIImageView()
    private lazy var phoneLabel = UILabel()
    private lazy var twitterButton = UIButton()
    private lazy var siteButton = UIButton()
    private lazy var facebookButton = UIButton()
    private lazy var instagramButton = UIButton()
    private lazy var infoLabel = UILabel()
    private lazy var urlButton = UIButton()
    private lazy var addPhotoButton = UIButton()
    private lazy var setBackgroundButton = UIButton()
    private let spacing: CGFloat = 1

    private lazy var photoCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        let width: CGFloat = bounds.width / 3 - 2 * spacing
        layout.itemSize = CGSize(width: width, height: width + spacing)
        return UICollectionView(frame: .zero, collectionViewLayout: layout)
    }()

    private(set) var photos: [UIImage?] = []

    // MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        background(.white())
        addPhotos()
        addProfileImage()
        addTitleLabel()
        addTwitterButton()
        addSiteButton()
        addFacebookButton()
        addInstButton()
        addPhoneLabel()
        addInfoLabel()
        addUrlButton()
        addAddPhotoButton()
        addPhotoCollectionView()
        addSetBackgroundButton()
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("not implemented")
    }

    // MARK: - Internal Methods

    func addPhotos() {
        for _ in 1...6 {
            photos.append(R.image.profileBackground.whiteGallery())
        }
    }

    // MARK: - Private Methods

    private func addProfileImage() {
        profileImage.snap(parent: self) {
            $0.image = profileDetail.image
            $0.clipCorners(radius: 50)
        } layout: {
            $0.width.height.equalTo(100)
            $0.top.equalTo(self.snp_topMargin).offset(24)
            $0.leading.equalTo($1).offset(16)
        }
    }

    private func addTitleLabel() {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.21
        paragraphStyle.alignment = .left

        titleLabel.snap(parent: self) {
            $0.titleAttributes(
                text: profileDetail.name,
                [
                    .paragraph(paragraphStyle),
                    .font(.medium(15)),
                    .color(.black())
                ]
            )
            $0.lineBreakMode = .byWordWrapping
            $0.numberOfLines = 0
            $0.textAlignment = .left
        } layout: {
            $0.top.equalTo(self.snp_topMargin).offset(27)
            $0.height.equalTo(18)
            $0.leading.equalTo($1).offset(132)
            $0.trailing.equalTo($1).offset(-45)
        }
    }

    private func addTwitterButton() {
        twitterButton.snap(parent: self) {
            let image = R.image.profile.twitter()
            $0.setImage(image, for: .normal)
        } layout: {
            $0.top.equalTo($1).offset(57)
            $0.leading.equalTo($1).offset(132)
            $0.height.width.equalTo(32)
        }
    }

    private func addSiteButton() {
        siteButton.snap(parent: self) {
            let image = R.image.profile.website()
            $0.setImage(image, for: .normal)
        } layout: {
            $0.height.width.equalTo(32)
            $0.top.equalTo($1).offset(57)
            $0.leading.equalTo($1).offset(172)
        }
    }

    private func addFacebookButton() {
        instagramButton.snap(parent: self) {
            let image = R.image.profile.facebook()
            $0.setImage(image, for: .normal)
        } layout: {
            $0.height.width.equalTo(32)
            $0.top.equalTo($1).offset(57)
            $0.leading.equalTo($1).offset(212)
        }
    }

    private func addInstButton() {
        facebookButton.snap(parent: self) {
            let image = R.image.profile.instagram()
            $0.setImage(image, for: .normal)
        } layout: {
            $0.height.width.equalTo(32)
            $0.top.equalTo($1).offset(57)
            $0.leading.equalTo($1).offset(252)
        }
    }

    private func addPhoneLabel() {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.15
        paragraphStyle.alignment = .left

        phoneLabel.snap(parent: self) {
            $0.titleAttributes(
                text: profileDetail.phone,
                [
                    .paragraph(paragraphStyle),
                    .font(.regular(15)),
                    .color(.black())
                ]
            )
            $0.textAlignment = .left
        } layout: {
            $0.top.equalTo(self.snp_topMargin).offset(101)
            $0.leading.equalTo(self.profileImage.snp.trailing).offset(16)
            $0.trailing.equalTo($1).offset(-45)
        }
    }

    private func addInfoLabel() {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.15
        paragraphStyle.alignment = .left

        infoLabel.snap(parent: self) {
            $0.titleAttributes(
                text: profileDetail.description,
                [
                    .paragraph(paragraphStyle),
                    .font(.regular(15)),
                    .color(.black())
                ]
            )
            $0.textAlignment = .left
            $0.numberOfLines = 0
        } layout: {
            $0.top.equalTo(self.phoneLabel.snp.bottom).offset(29)
            $0.leading.equalTo($1).offset(16)
            $0.trailing.equalTo($1).offset(-16)
        }
    }

    private func addUrlButton() {
        urlButton.snap(parent: self) {
            $0.titleLabel?.textAlignment = .left
            $0.titleAttributes(
                text: R.string.localizable.profileSite(),
                [
                    .font(.regular(15)),
                    .color(.blue())

                ]
            )
            $0.titleLabel?.lineBreakMode = .byCharWrapping
            $0.titleLabel?.numberOfLines = 2
        } layout: {
            $0.top.equalTo(self.infoLabel.snp.bottom).offset(1)
            $0.leading.equalTo($1).offset(16)
            $0.trailing.equalTo($1).offset(-16)
        }
    }

    private func addAddPhotoButton() {
        addPhotoButton.snap(parent: self) {
            $0.background(.clear)
            $0.layer.borderWidth(1)
            $0.layer.borderColor(.blue())
            $0.titleAttributes(
                text: R.string.localizable.profileAdd(),
                [
                    .font(.medium(15)),
                    .color(.blue())
                ]
            )
            $0.clipCorners(radius: 8)
        } layout: {
            $0.height.equalTo(44)
            $0.top.equalTo(self.urlButton.snp.bottom).offset(24)
            $0.leading.equalTo($1).offset(16)
            $0.trailing.equalTo($1).offset(-16)
        }
    }

    private func addPhotoCollectionView() {
        photoCollectionView.snap(parent: self) {
            $0.backgroundView = UIImageView(image: backgroundPreviewImage)
            $0.backgroundView?.contentMode = .scaleToFill
            $0.dataSource = self
            $0.delegate = self
            $0.register(ProfileBackgroundPreviewCell.self,
                        forCellWithReuseIdentifier: ProfileBackgroundPreviewCell.identifier)
        } layout: {
            $0.top.equalTo(self.addPhotoButton.snp.bottom).offset(24)
            $0.leading.equalTo($1)
            $0.trailing.equalTo($1)
            $0.bottom.equalTo($1)
        }
        photoCollectionView.reloadData()
    }

    private func addSetBackgroundButton() {
        setBackgroundButton.snap(parent: self) {
            $0.background(.black())
            $0.titleAttributes(
                text: R.string.localizable.profileBackgroundPreviewSetBackground(),
                [
                    .font(.medium(15)),
                    .color(.white())
                ]
            )
        } layout: {
            $0.leading.equalTo($1)
            $0.trailing.equalTo($1)
            $0.bottom.equalTo($1)
            $0.height.equalTo(68)
        }
    }
}

// MARK: - ProfileBackgroundPreviewView (UICollectionViewDataSource)

extension ProfileBackgroundPreviewView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeue(ProfileBackgroundPreviewCell.self,
                                                indexPath: indexPath) else { return .init() }
        cell.profileImageView.image = photos[indexPath.row]
        return cell
    }
}

// MARK: - ProfileBackgroundPreviewView (UICollectionViewDelegate)

extension ProfileBackgroundPreviewView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

    }
}
