import UIKit

protocol ReusableView: AnyObject {
    static var identifier: String { get }
}

final class ProfileCell: UICollectionViewCell {

    private lazy var profileImageView = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: .zero)
        addProfileImageView()
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("not implemented")
    }

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

extension ProfileCell: ReusableView {
    static var identifier: String {
        return String(describing: self)
    }
}
