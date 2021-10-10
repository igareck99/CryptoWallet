import UIKit

// MARK: - PaywallView

final class PaywallView: UIView {

    // MARK: - Internal Properties

    var didTabBuy: VoidBlock?
    var didCloseTap: VoidBlock?

    // MARK: - Private Properties

    private lazy var closeButton = UIButton()
    private lazy var buyLabel = UILabel()
    private lazy var auraImageView = UIImageView()
    private lazy var balanceLabel = UILabel()
    private lazy var yourBalanceLabel = UILabel()
    private lazy var buyButton = UIButton()

    // MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        background(.white())
        addCloseButton()
        addBuyLabel()
        addAuraImageView()
        addBalanceLabel()
        addBuyButton()
        addYourBalanceLabel()
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("not implemented")
    }

    // MARK: - Actions

    @objc private func closeAction() {
        didCloseTap?()
    }

    @objc private func BuyAction() {
        didCloseTap?()
    }

    // MARK: - Private Methods

    private func addCloseButton() {
        closeButton.snap(parent: self) {
            $0.setImage(R.image.buyCellsMenu.close(), for: .normal)
            $0.contentMode = .scaleAspectFill
            $0.addTarget(self, action: #selector(self.closeAction), for: .touchUpInside)
        } layout: {
            $0.top.leading.equalTo($1).offset(16)
            $0.width.height.equalTo(24)
        }
    }

    private func addBuyLabel() {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.24
        paragraphStyle.alignment = .center
        buyLabel.snap(parent: self) {
            $0.titleAttributes(
                text: R.string.localizable.buyCellTitle(),
                [
                    .paragraph(paragraphStyle),
                    .font(.medium(16)),
                    .color(.black())
                ]
            )
        } layout: {
            $0.top.equalTo($1).offset(16)
            $0.height.equalTo(24)
            $0.centerX.equalTo($1)
        }
    }

    private func addAuraImageView() {
        auraImageView.snap(parent: self) {
            $0.background(.lightBlue())
            $0.image = R.image.buyCellsMenu.aura()
            $0.contentMode = .center
            $0.clipCorners(radius: 40)
        } layout: {
            $0.width.height.equalTo(80)
            $0.top.equalTo(self.buyLabel.snp.bottom).offset(48)
            $0.centerX.equalTo($1)
        }
    }

    private func addBalanceLabel() {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.24
        paragraphStyle.alignment = .center
        balanceLabel.snap(parent: self) {
            $0.titleAttributes(
                text: "250.41 AUR",
                [
                    .paragraph(paragraphStyle),
                    .font(.medium(32)),
                    .color(.black())
                ]
            )
        } layout: {
            $0.top.equalTo(self.auraImageView.snp.bottom).offset(16)
            $0.centerX.equalTo($1)
        }
    }

    private func addYourBalanceLabel() {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 21
        paragraphStyle.alignment = .center
        yourBalanceLabel.snap(parent: self) {
            $0.titleAttributes(
                text: R.string.localizable.buyCellYourBalance(),
                [
                    .paragraph(paragraphStyle),
                    .font(.regular(15)),
                    .color(.darkGray())
                ]
            )
        } layout: {
            $0.bottom.equalTo(self.buyButton.snp.top).offset(-24)
            $0.centerX.equalTo($1)
        }
    }

    private func addBuyButton() {
        buyButton.snap(parent: self) {
            $0.background(.blue())
            $0.titleAttributes(
                text: R.string.localizable.buyCellBuy(),
                [
                    .font(.medium(15)),
                    .color(.white())
                ]
            )
            $0.clipCorners(radius: 8)
            $0.addTarget(self, action: #selector(self.BuyAction), for: .touchUpInside)
        } layout: {
            $0.height.equalTo(44)
            $0.leading.equalTo($1).offset(62)
            $0.trailing.equalTo($1).offset(-62)
            $0.bottom.equalTo($1).offset(-49)
        }
    }
}
