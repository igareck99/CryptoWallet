import UIKit

// MARK: - HeaderViewCell

final class HeaderViewCell: UITableViewCell {

    // MARK: - Internal Properties

    weak var delegate: ProfileDetailDelegate?
    var didTapPhoto: VoidBlock?

    // MARK: - Private Properties

    private lazy var backImageView = UIImageView()
    private lazy var cameraButton = UIButton()

    // MARK: - Lifecycle

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addBackImageView()
        addCameraButton()
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("not implemented")
    }

    // MARK: - Internal Methods

    func configure(_ type: ProfileDetailViewModel.SectionType) {
        backImageView.image = type.image
        cameraButton.setImage(R.image.profileDetail.camera(), for: .normal)
    }

    @objc func PhotoActionAdd(sender: UIButton) {
        print("soe weong")
        didTapPhoto?()
    }

    // MARK: - Private Methods

    private func addBackImageView() {
        backImageView.snap(parent: self) {
            $0.contentMode = .scaleAspectFill
        } layout: {
            $0.leading.trailing.top.equalTo($1)
            $0.height.equalTo(self.frame.width)
        }
    }

    private func addCameraButton() {
        cameraButton.snap(parent: self) {
            $0.contentMode = .center
            $0.setImage(R.image.profileDetail.camera(), for: .normal)
            $0.clipCorners(radius: 30)
            $0.background(.darkBlack(0.4))
            $0.addTarget(self, action: #selector(self.PhotoActionAdd), for: .touchUpInside)
        } layout: {
            $0.width.height.equalTo(60)
            $0.trailing.equalTo($1).offset(-16)
            $0.bottom.equalTo($1).offset(-36)
        }
    }
}
