import UIKit

// MARK: - GenerationInfoView

final class GenerationInfoView: UIView {

    // MARK: - Internal Properties

    var didTapInfoButton: VoidBlock?
    var didTapCreateButton: VoidBlock?
    var didTapImportButton: VoidBlock?

    // MARK: - Private Properties

    private lazy var titleLabel = UILabel()
    private lazy var descriptionLabel = UILabel()
    private lazy var infoImageView = UIImageView()
    private lazy var infoButton = UIButton()
    private lazy var createButton = UIButton()
    private lazy var importButton = UIButton()

    // MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        background(.white())
        addTitleLabel()
        addDescriptionLabel()
        addInfoButton()
        addInfoImageView()
        addCreateButton()
        addImportButton()
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("not implemented")
    }

    // MARK: - Actions

    @objc private func infoButtonTap() {
        vibrate()
        infoButton.animateScaleEffect {
            self.didTapInfoButton?()
        }
    }

    @objc private func createButtonTap() {
        vibrate()
        createButton.animateScaleEffect {
            self.didTapCreateButton?()
        }
    }

    @objc private func importButtonTap() {
        vibrate()
        importButton.animateScaleEffect {
            self.didTapImportButton?()
        }
    }

    // MARK: - Private Methods

    private func addTitleLabel() {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.15
        paragraphStyle.alignment = .center

        titleLabel.snap(parent: self) {
            $0.textAlignment = .center
            $0.numberOfLines = 0
            $0.titleAttributes(
                text: R.string.localizable.keyGenerationTitle(),
                [
                    .paragraph(paragraphStyle),
                    .font(.medium(22)),
                    .color(.black())
                ]
            )
        } layout: {
            $0.top.equalTo(self.snp_topMargin).offset(50)
            $0.leading.equalTo($1).offset(24)
            $0.trailing.equalTo($1).offset(-24)
            $0.height.greaterThanOrEqualTo(28)
        }
    }

    private func addDescriptionLabel() {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.24
        paragraphStyle.alignment = .center

        descriptionLabel.snap(parent: self) {
            $0.textAlignment = .center
            $0.numberOfLines = 0
            $0.titleAttributes(
                text: R.string.localizable.keyGenerationDescription(),
                [
                    .paragraph(paragraphStyle),
                    .font(.regular(15)),
                    .color(.gray())
                ]
            )
        } layout: {
            $0.top.equalTo(self.titleLabel.snp_bottomMargin).offset(16)
            $0.leading.equalTo($1).offset(24)
            $0.trailing.equalTo($1).offset(-24)
        }
    }

    private func addInfoButton() {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.24
        paragraphStyle.alignment = .center

        let title = R.string.localizable.keyGenerationInformation()

        infoButton.snap(parent: self) {
            $0.titleAttributes(
                text: title,
                [
                    .color(.blue()),
                    .font(.regular(15)),
                    .paragraph(paragraphStyle)
                ]
            )
            $0.addTarget(self, action: #selector(self.infoButtonTap), for: .touchUpInside)
        } layout: {
            $0.top.equalTo(self.descriptionLabel.snp_bottomMargin).offset(24)
            $0.leading.equalTo($1).offset(24)
            $0.trailing.equalTo($1).offset(-24)
        }
    }

    private func addInfoImageView() {
        infoImageView.snap(parent: self) {
            $0.image = R.image.keyGeneration.keyInfo()
            $0.contentMode = .scaleAspectFill
        } layout: {
            $0.top.equalTo(self.infoButton.snp_bottomMargin).offset(30)
            $0.centerX.equalTo($1)
        }
    }

    private func addCreateButton() {
        let paragraph = NSMutableParagraphStyle()
        paragraph.lineHeightMultiple = 1.09
        paragraph.alignment = .center

        createButton.snap(parent: self) {
            let title = R.string.localizable.keyGenerationCreateButton()
            $0.titleAttributes(
                text: title,
                [
                    .color(.white()),
                    .font(.semibold(15)),
                    .paragraph(paragraph)
                ]
            )
            $0.background(.blue())
            $0.clipCorners(radius: 8)
            $0.addTarget(self, action: #selector(self.createButtonTap), for: .touchUpInside)
        } layout: {
            $0.bottom.equalTo($1).offset(-100)
            $0.leading.equalTo($1).offset(67)
            $0.trailing.equalTo($1).offset(-67)
            $0.height.equalTo(44)
        }
    }

    private func addImportButton() {
        let paragraph = NSMutableParagraphStyle()
        paragraph.lineHeightMultiple = 1.09
        paragraph.alignment = .center

        importButton.snap(parent: self) {
            let title = R.string.localizable.keyGenerationUseButton()
            $0.titleAttributes(
                text: title,
                [
                    .color(.blue()),
                    .font(.semibold(15)),
                    .paragraph(paragraph)
                ]
            )
            $0.background(.clear)
            $0.clipCorners(radius: 8)
            $0.addTarget(self, action: #selector(self.importButtonTap), for: .touchUpInside)
        } layout: {
            $0.top.equalTo(self.createButton.snp.bottom).offset(21)
            $0.centerX.equalTo($1)
            $0.height.equalTo(19)
        }
    }
}
