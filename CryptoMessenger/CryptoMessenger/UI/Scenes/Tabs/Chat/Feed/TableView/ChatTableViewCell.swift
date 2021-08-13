import UIKit

// MARK: - ChatTableViewCell

final class ChatTableViewCell: UITableViewCell {

    // MARK: - Private Properties

    private lazy var iconBackView = UIView()
    private lazy var avatarImageView = UIImageView()
    private lazy var statusBackView = UIView()
    private lazy var statusView = UIView()
    private lazy var nameLabel = UILabel()
    private lazy var dateLabel = UILabel()
    private lazy var bottomStackView = UIStackView()
    private lazy var messageLabel = UILabel()
    private lazy var readImageView = UIImageView()
    private lazy var readStackView = UIStackView()
    private lazy var pinImageView = UIImageView()
    private lazy var unreadCountView = UIView()
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
        addAvatarImageView()
        addStatusView()
        addNameLabel()
        addDateLabel()
        addBottomStackView()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("not implemented")
    }

    // MARK: - Internal Methods

    func configure(_ message: Message) {
        switch message.type {
        case let .text(text):
            messageLabel.text = text
        default:
            break
        }

        avatarImageView.image = message.avatar
        nameLabel.text = message.name
        dateLabel.text = message.date
        unreadCountLabel.text = "\(message.unreadCount)"
        readStackView.isHidden = message.unreadCount != 0 || message.isPinned
        unreadCountView.alpha = CGFloat(message.unreadCount)
        statusView.background(message.status.color)
        pinImageView.isHidden = !message.isPinned || message.unreadCount != 0
    }

    // MARK: - Private Methods

    private func addAvatarImageView() {
        iconBackView.snap(parent: contentView) {
            $0.background(.clear)
        } layout: {
            $0.center.equalTo($1)
            $0.leading.equalTo($1).offset(17)
            $0.width.height.equalTo(60)
        }

        avatarImageView.snap(parent: iconBackView) {
            $0.contentMode = .scaleAspectFill
            $0.clipCorners(radius: 30)
        } layout: {
            $0.top.leading.trailing.bottom.equalTo($1)
        }
    }

    private func addStatusView() {
        statusBackView.snap(parent: iconBackView) {
            $0.clipCorners(radius: 8)
            $0.background(.white())
        } layout: {
            $0.width.height.equalTo(16)
            $0.bottom.equalTo($1)
            $0.trailing.equalTo($1)
        }

        statusView.snap(parent: statusBackView) {
            $0.clipCorners(radius: 6)
            $0.background(.white())
        } layout: {
            $0.width.height.equalTo(12)
            $0.center.equalTo($1)
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

    private func addBottomStackView() {
        readImageView.image = R.image.chat.readCheck()
        readImageView.contentMode = .center
        readImageView.snp.makeConstraints {
            $0.height.equalTo(8)
            $0.width.equalTo(13.5)
        }

        messageLabel.font(.regular(15))
        messageLabel.textColor(.black(0.8))
        messageLabel.textAlignment = .left
        messageLabel.numberOfLines = 0
        messageLabel.setContentCompressionResistancePriority(UILayoutPriority(1000), for: .horizontal)

        unreadCountView.snp.makeConstraints {
            $0.width.greaterThanOrEqualTo(20)
            $0.height.equalTo(20)
        }
        unreadCountView.background(.red())
        unreadCountView.clipCorners(radius: 10)

        unreadCountLabel.snap(parent: unreadCountView) {
            $0.top.equalTo($1).offset(2)
            $0.bottom.equalTo($1).offset(-2)
            $0.leading.equalTo($1).offset(6)
            $0.trailing.equalTo($1).offset(-6)
        }
        unreadCountLabel.font(.regular(13))
        unreadCountLabel.textColor(.white())
        unreadCountLabel.textAlignment = .center

        bottomStackView.snap(parent: contentView) {
            $0.spacing = 5
            $0.axis = .horizontal
            $0.alignment = .center
            $0.distribution = .fill
        } layout: {
            $0.top.equalTo(self.nameLabel.snp.bottom).offset(2)
            $0.leading.equalTo(self.avatarImageView.snp.trailing).offset(12)
            $0.trailing.equalTo($1).offset(-16)
            $0.bottom.equalTo($1).offset(-11)
        }

        readStackView.axis = .vertical
        readStackView.distribution = .fill
        readStackView.alignment = .top
        readStackView.snp.makeConstraints { $0.width.equalTo(13.5) }
        readStackView.addArrangedSubview(readImageView)
        readStackView.addArrangedSubview(UIView())

        pinImageView.image = R.image.chat.pin()
        pinImageView.contentMode = .center
        pinImageView.snp.makeConstraints { $0.width.height.equalTo(20) }

        bottomStackView.addArrangedSubview(readStackView)
        bottomStackView.addArrangedSubview(messageLabel)
        bottomStackView.addArrangedSubview(UIView())
        bottomStackView.addArrangedSubview(unreadCountView)
        bottomStackView.addArrangedSubview(pinImageView)
    }
}
