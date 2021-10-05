import UIKit

// MARK: - ProfileDetailCell

final class HeaderView: UIView {

    // MARK: - Internal Properties

    var customView = ProfileDetailView(frame: UIScreen.main.bounds)

    // MARK: - Private Properties

    private lazy var imageView = UIImageView()
    private lazy var cameraButton = UIButton()

    // MARK: - Lifecycle

    init(frame: CGRect, button: UIButton, imageView: UIImageView) {
        super.init(frame: frame)
        self.imageView = imageView
        self.cameraButton = button
        addImage()
        addCameraButton()
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("not implemented")
    }

    // MARK: - Private Methods

    private func addImage() {
        imageView.snap(parent: self) {
            $0.image = R.image.profileDetail.mainImage1()
            $0.contentMode = .scaleToFill
        } layout: {
            $0.leading.trailing.top.equalTo($1)
            $0.height.equalTo(377)
        }
    }

    private func addCameraButton() {
        cameraButton.snap(parent: self) {
            $0.contentMode = .scaleToFill
            $0.setImage(R.image.profileDetail.camera(), for: .normal)
            $0.clipCorners(radius: 30)
            $0.background(.darkBlack(0.4))
        } layout: {
            $0.width.height.equalTo(60)
            $0.trailing.equalTo($1).offset(-16)
            $0.top.equalTo($1).offset(301)
        }
    }
}
