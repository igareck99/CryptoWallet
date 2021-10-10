import UIKit

// MARK: - ProfileDetailDelegate

protocol ProfileDetailDelegate: AnyObject {
    func update(_ cell: UITableViewCell, _ textView: UITextView)
}

// MARK: - ProfileDetailCell

final class ProfileDetailCell: UITableViewCell {

    // MARK: - Internal Properties

    weak var delegate: ProfileDetailDelegate?

    // MARK: - Private Properties

    private lazy var inputTextView = UITextView()

    // MARK: - Lifecycle

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        addInputTextView()
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("not implemented")
    }

    // MARK: - Internal Methods

    func configure(_ text: String) {
        inputTextView.text = text
    }

    // MARK: - Private Methods

    private func addInputTextView() {
        inputTextView.snap(parent: contentView) {
            $0.showsVerticalScrollIndicator = false
            $0.showsHorizontalScrollIndicator = false
            $0.isScrollEnabled = false
            $0.textAlignment = .left
            $0.font(.regular(15))
            $0.textColor(.black())
            $0.background(.paleBlue())
            $0.clipCorners(radius: 8)
            $0.textContainerInset = .init(top: 12, left: 16, bottom: 12, right: 16)
            $0.delegate = self
        } layout: {
            $0.top.bottom.equalTo($1)
            $0.leading.equalTo($1).offset(16)
            $0.trailing.equalTo($1).offset(-16)
        }
    }
}

// MARK: - ProfileDetailCell (UITextViewDelegate)

extension ProfileDetailCell: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        delegate?.update(self, textView)
    }
}
