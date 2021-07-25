import UIKit

// MARK: - GenerationInfoView

final class GenerationInfoView: UIView {

    // MARK: - Internal Properties

    var didTapInfoButton: VoidBlock?
    var didTapNewKeyButton: VoidBlock?
    var didTapUseKeyButton: VoidBlock?

    // MARK: - Private Properties

    private lazy var titleLabel = UILabel()
    private lazy var descriptionLabel = UILabel()
    private lazy var infoImageView = UIImageView()
    private lazy var infoButton = UIButton()
    private lazy var createButton = UIButton()
    private lazy var useButton = UIButton()

    // MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        background(.white())
        addTitleLabel()
        addDescriptionLabel()
        addInfoImageView()
        addInfoButton()
        addCreateButton()
        addUseButton()
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
            self.didTapNewKeyButton?()
        }
    }

    @objc private func useButtonTap() {
        vibrate()
        useButton.animateScaleEffect {
            self.didTapUseKeyButton?()
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
            $0.top.equalTo(self.titleLabel.snp.bottom).offset(12)
            $0.leading.equalTo($1).offset(24)
            $0.trailing.equalTo($1).offset(-24)
        }
    }

    private func addInfoImageView() {
        infoImageView.snap(parent: self) {
            $0.image = R.image.keyGeneration.keyInfo()
            $0.contentMode = .scaleAspectFill
        } layout: {
            $0.top.equalTo(self.descriptionLabel.snp.bottom).offset(24)
            $0.centerX.equalTo($1)
        }
    }

    private func addInfoButton() {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.24
        paragraphStyle.alignment = .center

        let title = R.string.localizable.keyGenerationInformation()

        infoButton.snap(parent: self) {
            $0.titleAttributes(text: title, [.color(.blue()), .font(.regular(15)), .paragraph(paragraphStyle)])
            $0.addTarget(self, action: #selector(self.infoButtonTap), for: .touchUpInside)
        } layout: {
            $0.top.equalTo(self.infoImageView.snp.bottom).offset(24)
            $0.leading.equalTo($1).offset(24)
            $0.trailing.equalTo($1).offset(-24)
        }
    }

    private func addCreateButton() {
        createButton.snap(parent: self) {
            let title = R.string.localizable.keyGenerationCreateButton()
            $0.titleAttributes(text: title, [.color(.blue()), .font(.medium(15))])
            $0.background(.lightBlue())
            $0.clipCorners(radius: 8)
            $0.addTarget(self, action: #selector(self.createButtonTap), for: .touchUpInside)
        } layout: {
            $0.bottom.equalTo($1).offset(-102)
            $0.leading.equalTo($1).offset(80)
            $0.trailing.equalTo($1).offset(-80)
            $0.height.equalTo(44)
        }
    }

    private func addUseButton() {
        useButton.snap(parent: self) {
            let title = R.string.localizable.keyGenerationUseButton()
            $0.titleAttributes(text: title, [.color(.blue()), .font(.medium(15))])
            $0.background(.clear)
            $0.clipCorners(radius: 8)
            $0.addTarget(self, action: #selector(self.useButtonTap), for: .touchUpInside)
        } layout: {
            $0.leading.equalTo($1).offset(80)
            $0.trailing.equalTo($1).offset(-80)
            $0.height.equalTo(44)
            $0.bottom.equalTo(self.snp_bottomMargin).offset(-28)
        }
    }
}
