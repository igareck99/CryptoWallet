import UIKit

// MARK: - NetworkDetailCell

final class NetworkDetailCell: UITableViewCell {

    // MARK: - Private Properties

    private lazy var cellLabel = UILabel()
    private lazy var cellImage = UIImageView()
    private lazy var dragDropButton = UIButton()

    // MARK: - Lifecycle

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addMenuImage()
        addMenuLabel()
        addOpenButton()

    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("not implemented")
    }

    // MARK: - Internal Methods

    func configure(_ profile: NetworkDetailItem) {
        cellLabel.text = profile.text
        if profile.type == 0 {
            cellImage.image = R.image.profileNetworkDetail.cancelSmall()
        } else {
            cellImage.image = R.image.profileNetworkDetail.approveSmall()
        }
    }

    // MARK: - Private Methods

    private func addMenuImage() {
        cellImage.snap(parent: self) {
            $0.contentMode = .center
        } layout: {
            $0.width.height.equalTo(16)
            $0.leading.equalTo($1).offset(16)
            $0.centerY.equalTo($1)
        }
    }

    private func addMenuLabel() {
        cellLabel.snap(parent: self) {
            $0.font(.light(15))
            $0.textColor(.darkBlack())
        } layout: {
            $0.leading.equalTo($1).offset(48)
            $0.centerY.equalTo($1)
        }
    }

    private func addOpenButton() {
        dragDropButton.snap(parent: self) {
            $0.contentMode = .center
            $0.setImage(R.image.profileNetworkDetail.dragDrop(), for: .normal)
        } layout: {
            $0.width.height.equalTo(24)
            $0.trailing.equalTo($1).offset(-16)
            $0.top.equalTo($1).offset(12)
        }
    }
}
