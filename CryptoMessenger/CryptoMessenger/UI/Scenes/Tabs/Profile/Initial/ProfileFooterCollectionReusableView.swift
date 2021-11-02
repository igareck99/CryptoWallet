import UIKit

// MARK: - ProfileFooterCollectionReusableView

final class ProfileFooterCollectionReusableView: UICollectionReusableView {

    // MARK: - Internal Properties

    var didTapBuyCell: VoidBlock?
    static let identifier = "FooterProfileReusableView"

    // MARK: - Private Properties

    private lazy var buyButton = UIButton()

    // MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        addBuyButton()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Actions

    @objc private func BuyButtonTap() {
        didTapBuyCell?()
    }

    // MARK: - Private Methods

    private func addBuyButton() {
        buyButton.snap(parent: self) {
            $0.background(.clear)
            $0.layer.borderWidth(1)
            $0.layer.borderColor(.blue())
            $0.titleAttributes(
                text: R.string.localizable.profileBuyCell(),
                [
                    .font(.medium(15)),
                    .color(.blue())
                ]
            )
            $0.clipCorners(radius: 8)
            $0.addTarget(self, action: #selector(self.BuyButtonTap), for: .touchUpInside)
        } layout: {
            $0.height.equalTo(44)
            $0.top.equalTo($1).offset(26)
            $0.leading.equalTo($1).offset(16)
            $0.trailing.equalTo($1).offset(-16)
        }
    }
}
