import UIKit

// MARK: - ProfileView

final class ProfileView: UIView, UIImagePickerControllerDelegate {

    // MARK: - Internal Properties

    var didTap: (() -> Void)?

    // MARK: - Private Properties
    private lazy var view = ProfileView(frame: UIScreen.main.bounds)
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
    private var clearButton1 = UIButton()
    private var clearButton2 = UIButton()
    private var clearButton3 = UIButton()
    private var clearButton4 = UIButton()
    private var choosePhotoButton = UIButton()
    var profiles: [PhotoProfile] = []
    private let photocollectionView: UICollectionView = {
        let viewLayout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: viewLayout)
        collectionView.backgroundColor = .clear
        return collectionView
    }()

    // MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        background(.white())
        initProfiles()
        addProfileImage()
        addTitleLabel()
        addTwitterButton()
        addSiteButton()
        addFacebookButton()
        addInstButton()
        addPhoneLabel()
        addInfoLabel()
        addUrlButton()
        addaddPhotoButton()
        setupphotocollectionView()
        addphotocollectionView()
        photocollectionView.reloadData()

    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("not implemented")
    }

    // MARK: - Private Methods

    private func initProfiles() {
        let image = R.image.profile.toUploadImage()
        choosePhotoButton.setImage(image, for: .normal)
        profiles = [
                PhotoProfile(image: R.image.profile.testpicture2()!, button: clearButton1),
                PhotoProfile(image: R.image.profile.testpicture3()!, button: clearButton2),
                PhotoProfile(image: R.image.profile.testpicture4()!, button: clearButton3),
                PhotoProfile(image: R.image.profile.testpicture5()!, button: clearButton4),
                PhotoProfile(image: R.image.profile.toUpload()!, button: choosePhotoButton)
                    ]
    }

    private func addProfileImage() {
        profileImage.snap(parent: self) {
            $0.image = R.image.profile.userAvatar()
            $0.clipCorners(radius: 50)
        } layout: {
            $0.width.height.equalTo(100)
            $0.top.equalTo(self.snp_topMargin).offset(24)
            $0.leading.equalTo($1).offset(16)
        }
    }

    private func addTitleLabel() {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.15
        paragraphStyle.alignment = .left

        titleLabel.snap(parent: self) {
            $0.titleAttributes(
                text: R.string.localizable.profileTitle(),
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
                text: R.string.localizable.profileMobile(),
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
                text: R.string.localizable.profileInfo(),
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
            $0.titleLabel?.textAlignment = NSTextAlignment.left
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

    private func addaddPhotoButton() {
        addPhotoButton.snap(parent: self) {
            $0.backgroundColor = .clear
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor.blue.cgColor
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

    private func setupphotocollectionView() {
        photocollectionView.backgroundColor = .clear
        photocollectionView.dataSource = self
        photocollectionView.delegate = self
        photocollectionView.register(ProfileCell.self, forCellWithReuseIdentifier: ProfileCell.identifier)
    }

    private func addphotocollectionView() {
        photocollectionView.snap(parent: self) {
            $0.translatesAutoresizingMaskIntoConstraints = false
        } layout: {
            $0.top.equalTo(self.addPhotoButton.snp.bottom).offset(24)
            $0.leading.equalTo($1)
            $0.trailing.equalTo($1)
            $0.bottom.equalTo($1)
            }
    }
}

extension ProfileView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return profiles.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) ->
    UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProfileCell.identifier, for: indexPath)
                                                    as! ProfileCell
        let profile = profiles[indexPath.row]
        cell.setup(with: profile)
        return cell
    }

}

extension ProfileView: UICollectionViewDelegate {

}

extension ProfileView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {

        let width = itemWidth(for: view.frame.width, spacing: LayoutConstant.spacing)
        return CGSize(width: width, height: LayoutConstant.itemHeight)
    }

    func itemWidth(for width: CGFloat, spacing: CGFloat) -> CGFloat {
        let itemsInRow: CGFloat = 3
        let totalSpacing: CGFloat = 2 * spacing + (itemsInRow - 1) * spacing
        let finalWidth = (width - totalSpacing) / itemsInRow
        return finalWidth - 5.0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
            return UIEdgeInsets(top: LayoutConstant.spacing, left: LayoutConstant.spacing,
                                bottom: LayoutConstant.spacing, right: LayoutConstant.spacing)
        }

        func collectionView(_ collectionView: UICollectionView,
                            layout collectionViewLayout: UICollectionViewLayout,
                            minimumLineSpacingForSectionAt section: Int)
        -> CGFloat {
            return LayoutConstant.spacing
        }

        func collectionView(_ collectionView: UICollectionView,
                            layout collectionViewLayout: UICollectionViewLayout,
                            minimumInteritemSpacingForSectionAt section: Int)
        -> CGFloat {
            return LayoutConstant.spacing
        }
}

private enum LayoutConstant {
    static let spacing: CGFloat = 1.04
    static let itemHeight: CGFloat = 123.96
}

struct PhotoProfile {
    var image: UIImage
    var button: UIButton
}
