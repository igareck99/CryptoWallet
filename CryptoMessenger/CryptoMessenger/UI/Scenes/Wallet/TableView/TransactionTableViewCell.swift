import UIKit

// MARK: - TransactionTableViewCell

final class TransactionTableViewCell: UITableViewCell {

    // MARK: - Private Properties

    private lazy var iconBackView = UIView()
    private lazy var iconImageView = UIImageView()
    private lazy var typeLabel = UILabel()
    private lazy var cryptocurrencyLabel = UILabel()
    private lazy var currencyLabel = UILabel()
    private lazy var dateLabel = UILabel()

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
        addTypeLabel()
        addCryptocurrencyLabel()
        addDateLabel()
        addCurrencyLabel()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("not implemented")
    }

    // MARK: - Internal Methods

    func configure(_ transaction: Transaction) {
        iconBackView.background(transaction.type.color)
        iconImageView.image = transaction.type.icon
        typeLabel.text = transaction.type.name
        dateLabel.text = transaction.date
        currencyLabel.text = transaction.currency
        cryptocurrencyLabel.text = transaction.cryptocurrency

        if transaction.type == .inflow {
            cryptocurrencyLabel.textColor(.green())
        } else {
            cryptocurrencyLabel.textColor(.black())
        }
    }

    // MARK: - Private Methods

    private func addIconImageView() {
        iconBackView.snap(parent: contentView) {
            $0.background(.clear)
            $0.clipCorners(radius: 20)
        } layout: {
            $0.center.equalTo($1)
            $0.leading.equalTo($1).offset(16)
            $0.width.height.equalTo(40)
        }

        iconImageView.snap(parent: iconBackView) {
            $0.contentMode = .center
        } layout: {
            $0.top.leading.trailing.bottom.equalTo($1)
        }
    }

    private func addTypeLabel() {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.17
        paragraphStyle.alignment = .left

        typeLabel.snap(parent: self) {
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
            $0.top.equalTo($1).offset(16)
            $0.leading.equalTo(self.iconBackView.snp.trailing).offset(12)
            $0.height.equalTo(22)
        }
    }

    private func addCryptocurrencyLabel() {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.17
        paragraphStyle.alignment = .right

        cryptocurrencyLabel.snap(parent: self) {
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
            $0.top.equalTo($1).offset(16)
            $0.leading.equalTo(self.typeLabel.snp.trailing).offset(4)
            $0.trailing.equalTo($1).offset(-16)
            $0.height.equalTo(22)
        }
    }

    private func addDateLabel() {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.42
        paragraphStyle.alignment = .left

        dateLabel.snap(parent: self) {
//            $0.titleAttributes(
//                text: "",
//                [
//                    .paragraph(paragraphStyle),
//                    .font(.regular(13)),
//                    .color(.gray())
//                ]
//            )
            $0.font(.regular(13))
            $0.textColor(.gray())
            $0.textAlignment = .left
        } layout: { make, _ in
            make.top.equalTo(self.typeLabel.snp.bottom).offset(6)
            make.leading.equalTo(self.iconBackView.snp.trailing).offset(12)
        }
    }

    private func addCurrencyLabel() {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.17
        paragraphStyle.alignment = .right

        currencyLabel.snap(parent: self) {
//            $0.titleAttributes(
//                text: "",
//                [
//                    .paragraph(paragraphStyle),
//                    .font(.regular(15)),
//                    .color(.black())
//                ]
//            )
            $0.font(.regular(13))
            $0.textColor(.gray())
            $0.textAlignment = .right
            $0.setContentCompressionResistancePriority(UILayoutPriority(1000), for: .horizontal)
        } layout: {
            $0.top.equalTo(self.typeLabel.snp.bottom).offset(6)
            $0.leading.equalTo(self.dateLabel.snp.trailing).offset(4)
            $0.trailing.equalTo($1).offset(-16)
        }
    }
}
