import UIKit

// MARK: - AdditionalSessionCell

final class AdditionalSessionCell: UITableViewCell {

    // MARK: - Private Properties

    private lazy var titleLabel = UILabel()
    private lazy var dataLabel = UILabel()

    // MARK: - Lifecycle

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addTitleLabel()
        addDataLabel()
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("not implemented")
    }

    // MARK: - Internal Methods

    func configure(_ profile: AdditionalSessionItem) {
        titleLabel.text = profile.title
        dataLabel.text = profile.text
    }

    // MARK: - Private Methods

    private func addDataLabel() {
        dataLabel.snap(parent: self) {
            $0.font(.bold(15))
            $0.textColor(.black())
        } layout: {
            $0.leading.equalTo($1).offset(16)
            $0.top.equalTo($1).offset(23)
            $0.height.equalTo(21)
        }
    }

    private func addTitleLabel() {
        titleLabel.snap(parent: self) {
            $0.textColor(.gray())
            $0.font(.light(12))
            $0.textAlignment = .left
        } layout: {
            $0.top.equalTo($1).offset(5)
            $0.leading.equalTo($1).offset(16)
            $0.height.equalTo(16)
        }
    }
}
