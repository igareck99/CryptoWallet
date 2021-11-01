import UIKit

// MARK: - ProfileBackgroundPreviewCell

final class ProfileBackgroundPreviewCell: UICollectionViewCell {

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
            $0.centerX.centerY.equalTo($1)
            $0.width.equalTo(25)
            $0.height.equalTo(20)
        }
    }
}
