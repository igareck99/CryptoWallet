import UIKit

// MARK: - ProfileView

final class ProfileView: UIView {

    // MARK: - Internal Properties

    var didTap: (() -> Void)?
    // MARK: - Private Properties
    private lazy var TitleLabel = UILabel()
    private lazy var MobileLabel = UILabel()
    private lazy var ProfileImage = UIImageView()
    private lazy var twitterButton = UIButton(type: .custom)
    private lazy var siteButton = UIButton(type: .custom)
    private lazy var facebookButton = UIButton(type: .custom)
    private lazy var instagramButton = UIButton(type: .custom)
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        background(.white())
        addProfileImage()
        addTitleLabel()
        //addMobileLabel()
        addTwitterButton()
        addsiteButton()
        addfacebookButton()
        addinstButton()
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("not implemented")
    }

    // MARK: - Internal Methods

    // MARK: - Private Methods

    private func addTitleLabel() {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.15
        TitleLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        TitleLabel.numberOfLines = 0
        TitleLabel.snap(parent: self) {
                    $0.titleAttributes(
                        text: "ИКЕА Россия",
                        [
                            .paragraph(paragraphStyle),
                            .font(.medium(15)),
                            .color(.black())
                        ]
                    )
                    $0.textAlignment = .center
                    $0.numberOfLines = 0
                } layout: {
                    $0.top.equalTo(self.snp_topMargin).offset(27)
                    $0.leading.equalTo($1).offset(132)
                }
            }
    private func addProfileImage() {
        ProfileImage.snap(parent: self) {
            $0.image = R.image.profile.userAvatar()
                $0.layer.masksToBounds = false
                $0.contentMode = .scaleAspectFit
                $0.frame.size = CGSize(width: 100, height: 100) // размеры новой картинки
                $0.layer.cornerRadius = $0.frame.height / 2
                $0.clipsToBounds = true
                } layout: {
                    $0.top.equalTo(self.snp_topMargin).offset(24)
                    $0.leading.equalTo($1).offset(16)
                    $0.trailing.equalTo($1).offset(-259)
                }

    }
    private func addMobileLabel() {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 17.78
        paragraphStyle.alignment = .center
        TitleLabel.snap(parent: self) {
                    $0.titleAttributes(
                        text: "8 (925) 851-39-11",
                        [
                            .paragraph(paragraphStyle),
                            .font(.medium(15)),
                            .color(.black())
                        ]
                    )
                    $0.textAlignment = .center
                    $0.numberOfLines = 0
                } layout: {
                    $0.top.equalTo($1).offset(56)
                    $0.leading.equalTo(self.ProfileImage.snp.trailing).offset(16)
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
    private func addsiteButton() {
        twitterButton.snap(parent: self) {
            let image = R.image.profile.website()
            $0.setImage(image, for: .normal)
        } layout: {
            $0.height.width.equalTo(32)
            $0.top.equalTo($1).offset(57)
            $0.leading.equalTo($1).offset(181)
        }
    }
    private func addinstButton() {
        twitterButton.snap(parent: self) {
            let image = R.image.profile.instagram()
            $0.setImage(image, for: .normal)
        } layout: {
            $0.height.width.equalTo(32)
            $0.top.equalTo($1).offset(57)
            $0.leading.equalTo($1).offset(252)
        }
    }
    private func addfacebookButton() {
        twitterButton.snap(parent: self) {
            let image = R.image.profile.facebook()
            $0.setImage(image, for: .normal)
        } layout: {
            $0.height.width.equalTo(32)
            $0.top.equalTo($1).offset(57)
            $0.leading.equalTo($1).offset(212)
        }
    }

}
