import UIKit

// MARK: - PersonalizationCell

final class PersonalizationCell: UITableViewCell {

    // MARK: - Internal Properties

    var didTap: VoidBlock?

    // MARK: - Private Properties

    private lazy var titleLabel = UILabel()
    private lazy var currentStateLabel = UILabel()
    private lazy var arrowImageView = UIImageView()

    // MARK: - Lifecycle

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addTitleLabel()
        addCurrentStateLabel()
        addArrowImageView()
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("not implemented")
    }

    // MARK: - Internal Methods

    func configure(_ profile: PersonalizationItem) {
        titleLabel.text = profile.title
        currentStateLabel.text = profile.currentState
    }

    // MARK: - Actions

    @objc private func didTapOpen() {
        didTap?()
    }

    // MARK: - Private Methods

    private func addTitleLabel() {
        titleLabel.snap(parent: contentView) {
            $0.font(.regular(15))
            $0.textColor(.black())
        } layout: {
            $0.leading.equalTo($1).offset(16)
            $0.centerY.equalTo($1)
        }
    }

    private func addCurrentStateLabel() {
        currentStateLabel.snap(parent: contentView) {
            $0.textColor(.darkGray())
            $0.font(.light(15))
            $0.textAlignment = .right
        } layout: {
            $0.trailing.equalTo($1).offset(-48)
            $0.leading.equalTo($1).offset(140)
            $0.centerY.equalTo($1)
        }
    }

    private func addArrowImageView() {
        arrowImageView.snap(parent: contentView) {
            $0.contentMode = .center
            $0.image = R.image.additionalMenu.grayArrow()
        } layout: {
            $0.width.height.equalTo(24)
            $0.trailing.equalTo($1).offset(-23)
            $0.top.equalTo($1).offset(22)
        }
    }

}
