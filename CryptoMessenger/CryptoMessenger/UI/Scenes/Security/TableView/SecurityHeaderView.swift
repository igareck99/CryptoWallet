import UIKit

// MARK: - SecurityHeaderView

final class SecurityHeaderView: UIView {

    // MARK: - Private Properties

    private lazy var titleLabel = UILabel()

    // MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        addTitleLabel()
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("not implemented")
    }

    // MARK: - Private Methods

    private func addTitleLabel() {
        titleLabel.snap(parent: self) {
            $0.titleAttributes(
                text: R.string.localizable.securitySecurity(),
                [
                    .paragraph(.init(lineHeightMultiple: 1.22, alignment: .center)),
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
