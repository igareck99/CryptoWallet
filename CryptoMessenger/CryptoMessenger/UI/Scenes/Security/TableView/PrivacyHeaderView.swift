import UIKit

// MARK: - PrivacyHeaderView

final class PrivacyHeaderView: UIView {

    // MARK: - Private Properties

    private lazy var titleLabel = UILabel()
    private lazy var lineView = UIView()

    // MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        addLineView()
        addTitleLabel()
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("not implemented")
    }

    // MARK: - Private Methods

    private func addLineView() {
        lineView.background(.gray(0.8))
        lineView.snap(parent: self) {
            $0.height.equalTo(1)
            $0.top.equalTo($1).offset(16)
            $0.leading.trailing.equalTo($1)
        }
    }

    private func addTitleLabel() {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.22
        paragraphStyle.alignment = .center
        titleLabel.snap(parent: self) {
            $0.titleAttributes(
                text: R.string.localizable.securityPrivacy(),
                [
                    .paragraph(paragraphStyle),
                    .font(.bold(12)),
                    .color(.gray())
                ]
            )
            $0.lineBreakMode = .byWordWrapping
            $0.numberOfLines = 0
            $0.textAlignment = .left
        } layout: {
            $0.height.equalTo(22)
            $0.top.equalTo($1).offset(40)
            $0.leading.equalTo($1).offset(16)
        }
    }
}
