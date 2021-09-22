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
    private lazy var linksStack = UIStackView(arrangedSubviews: buttonsArray)
    private lazy var telephoneLabel = UILabel()
    private lazy var infoLabel = UILabel()
    private lazy var advertisementLabel = UILabel()
    private lazy var writeButton = UIButton()
    private lazy var callButton = UIButton()
    private lazy var butonsStack = UIStackView(arrangedSubviews: [buttons[0], buttons[1]])
    private var buttons: [UIButton] = []
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
        createButton(title: R.string.localizable.friendProfileWrite())
        createButton(title: R.string.localizable.friendProfileCall())
        configureButtons()
        addProfileImage()
        addNameLabel()
        addLinksStack()
        addTelephoneLabel()
        addInfoLabel()
        addAdvertisementLabel()
        addStackView()
        addPhotoCollectionView()
        print(linksStack.arrangedSubviews)

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

    @objc private func callButtonAction(sender: UIButton) {
        print("Call")
    }

    @objc private func writeButtonAction(sender: UIButton) {
        print("Write")
    }

    func createButton(title: String) {
        let button = UIButton()
        button.background(.clear)
        button.layer.borderWidth(1)
        button.layer.borderColor(.blue())
        button.clipCorners(radius: 8)
        button.titleAttributes(
            text: title,
            [
                .font(.medium(15)),
                .color(.blue())
            ]
        )
        if title == R.string.localizable.friendProfileCall() {
            button.addTarget(self, action: #selector(callButtonAction), for: .touchUpInside)
        } else {
            button.addTarget(self, action: #selector(writeButtonAction), for: .touchUpInside)
        }
        button.snp.makeConstraints { $0.height.equalTo(44) }
        buttons.append(button)
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
        linksStack.snap(parent: self) {
            $0.axis = .horizontal
            $0.spacing = 8
            $0.distribution = .fillEqually
            $0.alignment = .fill
            $0.translatesAutoresizingMaskIntoConstraints = false
        } layout: {
            $0.top.equalTo($1).offset(60)
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
        paragraphStyle.alignment = .left
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

    private func addAdvertisementLabel() {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.21
        paragraphStyle.alignment = .center
        advertisementLabel.snap(parent: self) {
            $0.titleAttributes(
                text: profile1.advertisement,
                [
                    .paragraph(paragraphStyle),
                    .font(.medium(15)),
                    .color(.black())
                ]
            )
            $0.lineBreakMode = .byWordWrapping
            $0.numberOfLines = 0
            $0.textAlignment = .left
            $0.background(.lightOrange(0.2))
        } layout: {
            $0.top.equalTo(self.infoLabel.snp.bottom).offset(8)
            $0.height.equalTo(64)
            $0.leading.equalTo($1).offset(16)
            $0.trailing.equalTo($1).offset(-16)
        }

    }

    private func addStackView() {
        butonsStack.snap(parent: self) {
            $0.axis = .horizontal
            $0.spacing = 12
            $0.distribution = .fillEqually
            $0.alignment = .fill
        } layout: {
            $0.centerX.equalTo($1)
            $0.leading.equalTo($1).offset(16)
            $0.trailing.equalTo($1).offset(-16)
            $0.top.equalTo($1).offset(291)
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
