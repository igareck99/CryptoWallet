import UIKit

// MARK: - ProfileView

final class ProfileView: UIView {

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
    // MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        background(.white())
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
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("not implemented")
    }

    // MARK: - Private Methods

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
            $0.setTitleColor(.systemBlue, for: .normal)
            $0.setTitle(R.string.localizable.profileSite(), for: .normal)
            $0.titleLabel?.textAlignment = NSTextAlignment.left
            $0.titleLabel?.font(.regular(15))
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
            $0.setTitleColor(UIColor(29, 150, 233), for: .normal)
            $0.setTitle(R.string.localizable.profileAdd(), for: .normal)
            $0.backgroundColor = .clear
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor.systemBlue.cgColor
            $0.titleLabel?.font(.regular(15))
            $0.clipCorners(radius: 8)
        } layout: {
            $0.height.equalTo(44)
            $0.top.equalTo(self.urlButton.snp.bottom).offset(24)
            $0.leading.equalTo($1).offset(16)
            $0.trailing.equalTo($1).offset(-16)
        }
    }
}
