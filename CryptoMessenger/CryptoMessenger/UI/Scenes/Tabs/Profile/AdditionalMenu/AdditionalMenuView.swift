import UIKit

// MARK: - AdditionalMenuView

final class AdditionalMenuView: UIView {

    // MARK: - Internal Properties

    var didTapDelete: VoidBlock?

    // MARK: - Private Properties

    private lazy var auraImage = UIImageView()
    private lazy var balanceLabel = UILabel()
    private lazy var firstLineView = UIView()
    private lazy var secondLineView = UIView()

    // MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        background(.white())
        setupAuraImage()
        setupBalanceLabel()
        addLineView()
        addSecondLineView()
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("not implemented")
    }

    // MARK: - Internal Methods

    @objc private func deleteButtonTap() {
        didTapDelete?()
    }

    // MARK: - Private Methods

    private func setupAuraImage() {
        auraImage.snap(parent: self) {
            $0.image = R.image.pinCode.aura()
            $0.contentMode = .scaleAspectFill
        } layout: {
            $0.width.height.equalTo(24)
            $0.top.equalTo(self.snp_topMargin).offset(18)
            $0.leading.equalTo($1).offset(16)
        }
    }

    private func setupBalanceLabel() {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.15
        paragraphStyle.alignment = .center
        balanceLabel.snap(parent: self) {
            $0.titleAttributes(
                text: "0.50 AUR",
                [
                    .paragraph(paragraphStyle),
                    .font(.regular(16)),
                    .color(.black())
                ]
            )
        } layout: {
            $0.top.equalTo(self.snp_topMargin).offset(19.7)
            $0.leading.equalTo($1).offset(48)
        }
    }

    private func addLineView() {
        firstLineView.snap(parent: self) {
            $0.background(.gray(0.4))
        } layout: {
            $0.top.equalTo($1).offset(58)
            $0.leading.trailing.equalTo($1)
            $0.height.equalTo(1)
        }
    }

    private func addSecondLineView() {
        secondLineView.snap(parent: self) {
            $0.background(.gray(0.4))
        } layout: {
            $0.top.equalTo($1).offset(534)
            $0.leading.trailing.equalTo($1)
            $0.height.equalTo(1)
        }
    }
}
