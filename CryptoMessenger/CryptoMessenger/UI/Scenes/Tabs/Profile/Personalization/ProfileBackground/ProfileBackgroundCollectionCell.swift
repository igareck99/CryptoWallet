import UIKit

// MARK: - ProfileBackgroundCollectionCell

final class ProfileBackgroundCollectionCell: UICollectionViewCell {

    // MARK: - Private Properties

    private(set) lazy var profileImageView = UIImageView()

    // MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: .zero)
        addProfileImageView()
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("not implemented")
    }

    // MARK: - Private Methods

    private func addProfileImageView() {
        profileImageView.snap(parent: self) {
            $0.contentMode = .scaleAspectFill
            $0.clipsToBounds = true
        } layout: {
            $0.leading.trailing.bottom.equalTo($1)
            $0.top.equalTo($1).offset(1.5)
        }
    }
}
