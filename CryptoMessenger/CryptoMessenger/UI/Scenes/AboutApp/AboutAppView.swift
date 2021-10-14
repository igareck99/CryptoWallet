import UIKit
import WebKit

// MARK: - AboutAppView

final class AboutAppView: UIView {

    // MARK: - Internal Properties

    var didTapLicense: VoidBlock?
    var didTapPolitics: VoidBlock?

    // MARK: - Private Properties

    private lazy var companyImage = UIImageView()
    private lazy var companyNameLabel = UILabel()
    private lazy var versionLabel = UILabel()
    private lazy var licenseButton = UIButton()
    private lazy var politicsTermsButton = UIButton()
    private lazy var appIncLabel = UILabel()

    // MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        background(.white())
        addCompanyImage()
        addCompanyNameLabel()
        addVersionLabel()
        addLicenseButton()
        addPoliticsTermsButton()
        addAppIncLabel()
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("not implemented")
    }

    // MARK: - Private Methods

    @objc private func licenseAction() {
        didTapLicense?()
    }

    @objc private func politicsTermsAction() {
        didTapPolitics?()
    }

    private func addCompanyImage() {
        companyImage.snap(parent: self) {
            $0.image = R.image.chat.logo()
            $0.contentMode = .scaleAspectFill
        } layout: {
            $0.width.height.equalTo(64)
            $0.top.equalTo($1).offset(138)
            $0.centerX.equalTo($1)
        }
    }

    private func addCompanyNameLabel() {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.21
        paragraphStyle.alignment = .center
        companyNameLabel.snap(parent: self) {
            $0.titleAttributes(
                text: AppConstants.appName.aboutApp,
                [
                    .paragraph(paragraphStyle),
                    .font(.semibold(15)),
                    .color(.black())
                ]
            )
        } layout: {
            $0.top.equalTo(self.companyImage.snp.bottomMargin).offset(22)
            $0.height.equalTo(21)
            $0.centerX.equalTo($1)
        }
    }

    private func addVersionLabel() {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.21
        paragraphStyle.alignment = .center
        versionLabel.snap(parent: self) {
            $0.titleAttributes(
                text: AppConstants.appVersion.aboutApp,
                [
                    .paragraph(paragraphStyle),
                    .font(.semibold(13)),
                    .color(.darkGray())
                ]
            )
        } layout: {
            $0.top.equalTo(self.companyNameLabel.snp.bottomMargin).offset(7)
            $0.height.equalTo(16)
            $0.centerX.equalTo($1)
        }
    }

    private func addLicenseButton() {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.23
        paragraphStyle.alignment = .center
        licenseButton.snap(parent: self) {
            $0.titleAttributes(
                text: R.string.localizable.aboutAppLicense(),
                [
                    .paragraph(paragraphStyle),
                    .font(.semibold(15)),
                    .color(.blue())
                ]
            )
            $0.addTarget(self, action: #selector(self.licenseAction), for: .touchUpInside)
        } layout: {
            $0.top.equalTo(self.versionLabel.snp.bottomMargin).offset(62)
            $0.height.equalTo(23)
            $0.centerX.equalTo($1)
        }
    }

    private func addPoliticsTermsButton() {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.23
        paragraphStyle.alignment = .center
        politicsTermsButton.snap(parent: self) {
            $0.titleAttributes(
                text: R.string.localizable.aboutAppTermsAndPolitics(),
                [
                    .paragraph(paragraphStyle),
                    .font(.semibold(15)),
                    .color(.blue())
                ]
            )
            $0.titleLabel?.numberOfLines = 0
            $0.titleLabel?.lineBreakMode = .byWordWrapping
            $0.addTarget(self, action: #selector(self.politicsTermsAction), for: .touchUpInside)
        } layout: {
            $0.top.equalTo(self.licenseButton.snp.bottomMargin).offset(16)
            $0.height.equalTo(46)
            $0.centerX.equalTo($1)
        }
    }

    private func addAppIncLabel() {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.21
        paragraphStyle.alignment = .center
        appIncLabel.snap(parent: self) {
            $0.titleAttributes(
                text: R.string.localizable.aboutAppAuraAppInc(),
                [
                    .paragraph(paragraphStyle),
                    .font(.semibold(13)),
                    .color(.darkGray())
                ]
            )
        } layout: {
            $0.bottom.equalTo($1).offset(-76)
            $0.height.equalTo(16)
            $0.centerX.equalTo($1)
        }
    }

}
