import UIKit

// MARK: - ChatTableViewCell

final class ChatTableViewCell: UITableViewCell {

    // MARK: - Private Properties

    private lazy var iconBackView = UIView()
    private lazy var iconImageView = UIImageView()
    private lazy var nameLabel = UILabel()
    private lazy var dateLabel = UILabel()
    private lazy var messageLabel = UILabel()
    private lazy var unreadCountLabel = UILabel()

    private var animator = TapAnimator()

    // MARK: - Internal Properties

    override var isHighlighted: Bool {
        didSet {
            if isHighlighted {
                animator.start(view: self)
            } else {
                animator.finish()
            }
        }
    }

    // MARK: - Lifecycle

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        addIconImageView()
        addNameLabel()
        addDateLabel()
        addMessageLabel()
        addUnreadCountLabel()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("not implemented")
    }

    // MARK: - Internal Methods

    func configure(_ message: Message) {
        iconBackView.background(.custom(#colorLiteral(red: 0.07450980392, green: 0.7215686275, blue: 0.9882352941, alpha: 1)))
        iconImageView.image = message.icon
        nameLabel.text = message.name
        dateLabel.text = message.date
        messageLabel.text = message.message
        unreadCountLabel.text = message.unreadMessagesCount.description
    }

    // MARK: - Private Methods

    private func addIconImageView() {
        iconBackView.snap(parent: contentView) {
            $0.background(.clear)
            $0.clipCorners(radius: 29)
        } layout: {
            $0.center.equalTo($1)
            $0.leading.equalTo($1).offset(17)
            $0.width.height.equalTo(58)
        }

        iconImageView.snap(parent: iconBackView) {
            $0.contentMode = .center
        } layout: {
            $0.top.leading.trailing.bottom.equalTo($1)
        }
    }

    private func addNameLabel() {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.17
        paragraphStyle.alignment = .left

        nameLabel.snap(parent: self) {
//            $0.titleAttributes(
//                text: "",
//                [
//                    .paragraph(paragraphStyle),
//                    .font(.semibold(15)),
//                    .color(.black())
//                ]
//            )
            $0.font(.semibold(15))
            $0.textColor(.black())
            $0.textAlignment = .left
        } layout: {
            $0.top.equalTo($1).offset(13)
            $0.leading.equalTo(self.iconBackView.snp.trailing).offset(13)
            $0.height.equalTo(22)
        }
    }

    private func addDateLabel() {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.17
        paragraphStyle.alignment = .right

        dateLabel.snap(parent: self) {
//            $0.titleAttributes(
//                text: "",
//                [
//                    .paragraph(paragraphStyle),
//                    .font(.regular(15)),
//                    .color(.black())
//                ]
//            )
            $0.font(.regular(15))
            $0.textColor(.black())
            $0.textAlignment = .right
            $0.setContentCompressionResistancePriority(UILayoutPriority(1000), for: .horizontal)
        } layout: {
            $0.top.equalTo($1).offset(13)
            $0.leading.equalTo(self.nameLabel.snp.trailing).offset(4)
            $0.trailing.equalTo($1).offset(-16)
            $0.height.equalTo(22)
        }
    }

    private func addMessageLabel() {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.42
        paragraphStyle.alignment = .left

        messageLabel.snap(parent: self) {
//            $0.titleAttributes(
//                text: "",
//                [
//                    .paragraph(paragraphStyle),
//                    .font(.regular(13)),
//                    .color(.gray())
//                ]
//            )
            $0.font(.regular(15))
            $0.textColor(.black(0.8))
            $0.textAlignment = .left
        } layout: { make, _ in
            make.top.equalTo(self.nameLabel.snp.bottom).offset(2)
            make.leading.equalTo(self.iconBackView.snp.trailing).offset(13)
        }
    }

    private func addUnreadCountLabel() {
        unreadCountLabel.snap(parent: self) {
            $0.font(.regular(13))
            $0.textColor(.white())
            $0.background(.red())
            $0.textAlignment = .center
            $0.clipCorners(radius: 10)
            $0.setContentCompressionResistancePriority(UILayoutPriority(1000), for: .horizontal)
        } layout: {
            $0.width.height.equalTo(20)
            $0.top.equalTo(self.dateLabel.snp.bottom).offset(2)
            $0.leading.greaterThanOrEqualTo(self.messageLabel.snp.trailing).offset(5)
            $0.trailing.equalTo($1).offset(-16)
        }
    }
}
