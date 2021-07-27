import UIKit

// MARK: - ProfileView

final class ProfileView: UIView {

    // MARK: - Internal Properties

    var didTap: (() -> Void)?
    // MARK: - Private Properties
    private lazy var TitleLabel = UILabel()
    private lazy var MobileLabel = UILabel()
    private lazy var ProfileImage = UIImageView()
    private lazy var SocButton = UIButton(type: .custom)
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        background(.white())
        addProfileImage()
        addTitleLabel()
        //addTwitterButton()
        addMobileLabel()
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
                    $0.top.equalTo($1).offset(27)
                    $0.leading.equalTo(self.ProfileImage.snp.trailing).offset(16)
                }
            }
    private func addProfileImage() {
        ProfileImage.snap(parent: self) {
                $0.image = UIImage(named: "Oval")
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
                    $0.top.equalTo(self.TitleLabel.snp.bottom).offset(56)
                    $0.leading.equalTo(self.ProfileImage.snp.trailing).offset(16)
                    $0.trailing.equalTo($1).offset(-45)
                }
    }
    private func addTwitterButton() {
        SocButton.snap(parent: self) {
            // открыть картинку, отмасштабировать, закрыть
            // $0.backgroundColor = UIColor(
            $0.layer.cornerRadius = 0.5 * $0.bounds.size.width
            $0.clipsToBounds = true
            $0.frame.size = CGSize(width: 32, height: 32)
            let image = UIImage(named: "Vector")
            $0.setImage(image, for: .normal)
                } layout: {
                    $0.top.equalTo($1).offset(200)
                    $0.leading.equalTo($1).offset(16)
                    $0.trailing.equalTo($1).offset(-259)
                }
    }

}
