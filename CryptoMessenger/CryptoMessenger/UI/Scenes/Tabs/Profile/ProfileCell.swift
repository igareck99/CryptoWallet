import UIKit

// MARK: - ProfileCell

final class ProfileCell: UICollectionViewCell {

    // MARK: - Private Properties

    private lazy var profileImageView = UIImageView()

    // MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: .zero)
        addProfileImageView()
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("not implemented")
    }

    // MARK: - Internal Methods

    func configure(_ profile: PhotoProfile) {
        profileImageView.image = profile.image
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
