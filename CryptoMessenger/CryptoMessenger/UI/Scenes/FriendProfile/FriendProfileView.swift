import UIKit

// MARK: - FriendProfileView

final class FriendProfileView: UIView {

    // MARK: - Internal Properties

    var didTap: (() -> Void)?

    // MARK: - Private Properties

    private lazy var profileImage = UIImageView()
    private lazy var nameLabel = UILabel()
    private lazy var twitterButton = UIButton()
    private lazy var siteButton = UIButton()
    private lazy var facebookButton = UIButton()
    private lazy var instagramButton = UIButton()
    private lazy var buttonsArray: [UIButton] = [twitterButton, siteButton, facebookButton, instagramButton]
    private lazy var linksStack = UIStackView()
    private lazy var telephoneLabel = UILabel()
    private lazy var infoLabel = UILabel()
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

    // MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        background(.white())
        configureButtons()
        addProfileImage()
        addNameLabel()
        //addLinksStack()
        addTelephoneLabel()
        addInfoLabel()
        addPhotoCollectionView()
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("not implemented")
    }

    // MARK: - Internal Methods

    func configureButtons() {
        buttonsArray[0].setImage(R.image.profile.twitter(), for: .normal)
        buttonsArray[1].setImage(R.image.profile.website(), for: .normal)
        buttonsArray[2].setImage(R.image.profile.facebook(), for: .normal)
        buttonsArray[3].setImage(R.image.profile.instagram(), for: .normal)
    }

    // MARK: - Private Methods

    private func addProfileImage() {
        profileImage.snap(parent: self) {
            if profile1.photo != nil {
                $0.image = profile1.photo
            } else {
                $0.image = R.image.friendProfile.photoNone()
            }
            $0.contentMode = .scaleAspectFill
            $0.background(.lightBlue())
            $0.clipCorners(radius: 50)
        } layout: {
            $0.width.height.equalTo(100)
            $0.top.equalTo(self.snp_topMargin).offset(24)
            $0.leading.equalTo($1).offset(16)
        }
    }

    private func addNameLabel() {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.21
        paragraphStyle.alignment = .center
        nameLabel.snap(parent: self) {
            $0.titleAttributes(
                text: profile1.name,
                [
                    .paragraph(paragraphStyle),
                    .font(.semibold(15)),
                    .color(.black())
                ]
            )
            $0.lineBreakMode = .byWordWrapping
            $0.numberOfLines = 0
            $0.textAlignment = .left
        } layout: {
            $0.top.equalTo($1).offset(29)
            $0.height.equalTo(18)
            $0.leading.equalTo($1).offset(132)
            $0.trailing.equalTo($1).offset(-45)
        }
    }

    private func addLinksStack() {
        for (index, element) in profile1.links.enumerated() where element != 0 {
            linksStack.addSubview(buttonsArray[index])
        }
        linksStack.snap(parent: self) {
            $0.axis = .horizontal
            $0.spacing = 8
            $0.distribution = .fillEqually
            $0.alignment = .fill
            $0.translatesAutoresizingMaskIntoConstraints = false
        } layout: {
            $0.top.equalTo($1).offset(60)
            $0.trailing.greaterThanOrEqualTo(-100)
            $0.leading.equalTo($1).offset(132)
        }
    }

    private func addTelephoneLabel() {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.21
        paragraphStyle.alignment = .center
        telephoneLabel.snap(parent: self) {
            $0.titleAttributes(
                text: profile1.telephone,
                [
                    .paragraph(paragraphStyle),
                    .font(.regular(15)),
                    .color(.black())
                ]
            )
            $0.lineBreakMode = .byWordWrapping
            $0.numberOfLines = 0
            $0.textAlignment = .left
        } layout: {
            $0.top.equalTo(self.nameLabel.snp.bottom).offset(53)
            $0.leading.equalTo(self.profileImage.snp.trailing).offset(16)
            $0.trailing.equalTo($1).offset(-45)
        }

    }

    private func addInfoLabel() {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.21
        paragraphStyle.alignment = .center
        infoLabel.snap(parent: self) {
            $0.titleAttributes(
                text: profile1.info,
                [
                    .paragraph(paragraphStyle),
                    .font(.regular(15)),
                    .color(.black())
                ]
            )
            $0.lineBreakMode = .byWordWrapping
            $0.numberOfLines = 0
            $0.textAlignment = .left
        } layout: {
            $0.top.equalTo($1).offset(151)
            $0.height.equalTo(44)
            $0.leading.equalTo($1).offset(16)
            $0.trailing.equalTo($1).offset(-16)
        }
    }

    private func addPhotoCollectionView() {
        photoCollectionView.snap(parent: self) {
            $0.background(.clear)
            $0.dataSource = self
            $0.delegate = self
            $0.register(ProfileCell.self, forCellWithReuseIdentifier: ProfileCell.identifier)
        } layout: {
            $0.top.equalTo($1).offset(359)
            $0.leading.equalTo($1)
            $0.trailing.equalTo($1)
            $0.bottom.equalTo($1)
        }
        photoCollectionView.reloadData()
    }
}

// MARK: - FriendProfileView (UICollectionViewDataSource)

extension FriendProfileView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return profile1.images.count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        var images: [PhotoProfile] = []
        for x in profile1.images {
            images.append(PhotoProfile(image: x))
        }
        guard let cell = collectionView.dequeue(ProfileCell.self, indexPath: indexPath) else { return .init() }
        cell.configure(images[indexPath.row])
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {}
}

// MARK: - FriendProfileView (UICollectionViewDelegate)

extension FriendProfileView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

    }
}
