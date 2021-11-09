import UIKit

// MARK: - ProfileHeaderCollectionReusableView

final class ProfileHeaderCollectionReusableView: UICollectionReusableView {

    // MARK: - Internal Properties

    var didTap: VoidBlock?
    var didTapAddPhoto: VoidBlock?
    static let identifier = "HeaderProfileReusableView"

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

    // MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
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
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("not implemented")
    }

    // MARK: - Actions

    @objc private func addPhotoButtonTap() {
        didTapAddPhoto?()
    }

    // MARK: - Private Methods

    private func addProfileImage() {
        profileImage.snap(parent: self) {
            $0.image = profileDetail.image
            $0.clipCorners(radius: 50)
        } layout: {
            $0.width.height.equalTo(100)
            $0.leading.equalTo($1).offset(16)
            $0.top.equalTo($1).offset(27)
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
            $0.top.equalTo($1).offset(29)
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
            $0.top.equalTo(self.titleLabel.snp.bottom).offset(10)
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
            $0.top.equalTo(self.titleLabel.snp.bottom).offset(10)
            $0.leading.equalTo($1).offset(172)
        }
    }

    private func addFacebookButton() {
        instagramButton.snap(parent: self) {
            let image = R.image.profile.facebook()
            $0.setImage(image, for: .normal)
        } layout: {
            $0.height.width.equalTo(32)
            $0.top.equalTo(self.titleLabel.snp.bottom).offset(10)
            $0.leading.equalTo($1).offset(212)
        }
    }

    private func addInstButton() {
        facebookButton.snap(parent: self) {
            let image = R.image.profile.instagram()
            $0.setImage(image, for: .normal)
        } layout: {
            $0.height.width.equalTo(32)
            $0.top.equalTo(self.titleLabel.snp.bottom).offset(10)
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
            $0.top.equalTo(self.titleLabel.snp.bottom).offset(53)
            $0.leading.equalTo($1).offset(132)
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
            $0.top.equalTo(self.profileImage.snp.bottom).offset(24)
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
            $0.addTarget(self, action: #selector(self.addPhotoButtonTap), for: .touchUpInside)
        } layout: {
            $0.height.equalTo(44)
            $0.top.equalTo(self.urlButton.snp.bottom).offset(24)
            $0.leading.equalTo($1).offset(16)
            $0.trailing.equalTo($1).offset(-16)
        }
    }
}
