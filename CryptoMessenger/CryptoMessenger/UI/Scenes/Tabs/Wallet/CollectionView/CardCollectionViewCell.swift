import UIKit

// MARK: - CardCollectionViewCell

final class CardCollectionViewCell: UICollectionViewCell {

    // MARK: - Private Properties

    private lazy var backgroundImageView = UIImageView()
    private var animator = TapAnimator()

    // MARK: - Internal Properties

    override var isHighlighted: Bool {
        didSet {
            if isHighlighted {
                //animator.start(view: self)
            } else {
                //animator.finish()
            }
        }
    }

    // MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        addBackgroundImageView()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("not implemented")
    }

    // MARK: - Private Methods

    private func addBackgroundImageView() {
        backgroundImageView.snap(parent: contentView) {
            $0.image = R.image.wallet.card()
            $0.contentMode = .scaleAspectFill
        } layout: {
            $0.top.leading.trailing.bottom.equalTo($1)
        }
    }
}
