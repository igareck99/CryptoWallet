import UIKit

// MARK: - ProfileDetailTableHeaderView

final class ProfileDetailTableHeaderView: UIView {

    // MARK: - Private Properties

    private lazy var backImageView = UIImageView()
    private lazy var cameraButton = UIButton()

    // MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        addBackImageView()
        addCameraButton()
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("not implemented")
    }

    // MARK: - Private Methods

    private func addBackImageView() {
        backImageView.snap(parent: self) {
            $0.image = R.image.profileDetail.mainImage1()
            $0.contentMode = .scaleToFill
        } layout: {
            $0.leading.trailing.top.equalTo($1)
            $0.height.equalTo(self.frame.width)
        }
    }

    private func addCameraButton() {
        cameraButton.snap(parent: self) {
            $0.contentMode = .center
            $0.clipCorners(radius: 30)
            $0.background(.black(0.4))
            $0.setImage(R.image.profileDetail.camera(), for: .normal)
        } layout: {
            $0.width.height.equalTo(60)
            $0.trailing.equalTo($1).offset(-16)
            $0.bottom.equalTo($1).offset(-16)
        }
    }
}
