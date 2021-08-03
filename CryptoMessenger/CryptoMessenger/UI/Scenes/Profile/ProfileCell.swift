import UIKit

// MARK: - ProfileCell (AnyObject)

protocol ReusableView: AnyObject {
    static var identifier: String { get }
}

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

    // MARK: - Private Methods

    private func addProfileImageView() {
        profileImageView.snap(parent: self) {
            $0.contentMode = .scaleAspectFill
        } layout: {
            $0.top.equalTo(self.snp_topMargin)
            $0.leading.equalTo($1)
            $0.trailing.equalTo($1)
            }
    }

    func setup(with profile: PhotoProfile) {
        profileImageView.image = profile.image
    }
}

// MARK: - ProfileCell (ReusableView)

extension ProfileCell: ReusableView {
    static var identifier: String {
        return String(describing: self)
    }
}
