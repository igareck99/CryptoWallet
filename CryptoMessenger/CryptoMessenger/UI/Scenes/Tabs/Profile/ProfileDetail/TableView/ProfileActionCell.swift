import UIKit

// MARK: - ProfileActionCell

final class ProfileActionCell: UITableViewCell {

    // MARK: - Internal Properties

    var didTap: VoidBlock?

    // MARK: - Private Properties

    private lazy var iconImageView = UIImageView()
    private lazy var titleLabel = UILabel()
    private lazy var arrowImageView = UIImageView()

    // MARK: - Lifecycle

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        addIconImageView()
        addTitleLabel()
        addArrowImageView()
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("not implemented")
    }

    // MARK: - Internal Methods

    func configure(_ type: ProfileDetailViewModel.SectionType) {
        iconImageView.image = type.image
        iconImageView.background(type.imageColor)
        arrowImageView.alpha = type == .socialNetwork ? 1 : 0
        titleLabel.titleAttributes(
            text: type.title ?? "",
            [
                .color(.black()),
                .font(.regular(15)),
                .paragraph(.init(lineHeightMultiple: 1.17, alignment: .center))
            ]
        )
    }

    // MARK: - Private Methods

    private func addIconImageView() {
        iconImageView.snap(parent: contentView) {
            $0.clipCorners(radius: 20)
            $0.contentMode = .center
        } layout: {
            $0.width.height.equalTo(40)
            $0.leading.equalTo($1).offset(16)
            $0.centerY.equalTo($1)
        }
    }

    private func addTitleLabel() {
        titleLabel.snap(parent: contentView) {
            $0.numberOfLines = 1
        } layout: {
            $0.leading.equalTo(self.iconImageView.snp.trailing).offset(16)
            $0.centerY.equalTo($1)
        }
    }

    private func addArrowImageView() {
        arrowImageView.snap(parent: contentView) {
            $0.contentMode = .center
            $0.alpha = 0
            $0.image = R.image.profileDetail.arrow()
        } layout: {
            $0.width.height.equalTo(24)
            $0.leading.equalTo(self.titleLabel.snp.trailing).offset(4)
            $0.trailing.equalTo($1).offset(-16)
            $0.centerY.equalTo($1)
        }
    }
}
