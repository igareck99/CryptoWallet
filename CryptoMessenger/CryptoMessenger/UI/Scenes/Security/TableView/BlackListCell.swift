import UIKit

// MARK: - BlackListCell

class BlackListCell: UITableViewCell {

    // MARK: - Internal Properties

    var didSwitchTap: VoidBlock?

    // MARK: - Private Properties

    private lazy var titleLabel = UILabel()
    private lazy var descriptionLabel = UILabel()
    private lazy var arrowImageView = UIImageView()

    // MARK: - Lifecycle

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addTitleLabel()
        addDescriptionLabel()
        addArrowImageView()

    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("not implemented")
    }

    // MARK: - Internal Methods

    func configure(_ profile: SecurityItem) {
        titleLabel.text = profile.title
        descriptionLabel.text = profile.currentState
    }

    // MARK: - Private Methods

    private func addTitleLabel() {
        titleLabel.snap(parent: self) {
            $0.font(.regular(15))
            $0.textColor(.black())
        } layout: {
            $0.leading.equalTo($1).offset(16)
            $0.top.equalTo($1).offset(21)
            $0.height.equalTo(21)
        }
    }

    private func addDescriptionLabel() {
        descriptionLabel.snap(parent: self) {
            $0.textColor(.blue())
            $0.font(.light(15))
            $0.textAlignment = .left
        } layout: {
            $0.top.equalTo($1).offset(21)
            $0.trailing.equalTo($1).offset(-48)
            $0.height.equalTo(21)
        }
    }

    private func addArrowImageView() {
        arrowImageView.snap(parent: self) {
            $0.contentMode = .center
            $0.image = R.image.additionalMenu.grayArrow()
        } layout: {
            $0.width.height.equalTo(24)
            $0.trailing.equalTo($1).offset(-23)
            $0.top.equalTo($1).offset(22)
        }
    }
}
