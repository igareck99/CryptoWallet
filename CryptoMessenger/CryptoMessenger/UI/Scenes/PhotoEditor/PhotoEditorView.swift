import UIKit

// MARK: - PhotoEditorView

final class PhotoEditorView: UIView {

    // MARK: - Internal Properties

    var didTapShare: VoidBlock?

    // MARK: - Private Properties

    private lazy var shareButton = UIButton()
    private lazy var brushButton = UIButton()
    private lazy var dateLabel = UILabel()

    // MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        addShareButton()
        addBrushButton()
        addDateLabel()
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("not implemented")
    }

    // MARK: - Internal Methods

    @objc private func shareButtonAction() {
        didTapShare?()
    }

    // MARK: - Private Methods

    private func addShareButton() {
        shareButton.snap(parent: self) {
            $0.setImage(R.image.photoEditor.share(), for: .normal)
            $0.contentMode = .scaleAspectFill
            $0.addTarget(self, action: #selector(self.shareButtonAction), for: .touchUpInside)
        } layout: {
            $0.leading.equalTo($1).offset(20)
            $0.bottom.equalTo($1).offset(-32)
            $0.width.height.equalTo(24)
        }
    }

    private func addBrushButton() {
        brushButton.snap(parent: self) {
            $0.setImage(R.image.callList.deleteimage(), for: .normal)
            $0.contentMode = .scaleAspectFill
        } layout: {
            $0.trailing.equalTo($1).offset(-16)
            $0.bottom.equalTo($1).offset(-32)
            $0.width.height.equalTo(24)
        }
    }

    private func addDateLabel() {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.15
        paragraphStyle.alignment = .center
        dateLabel.snap(parent: self) {
            $0.titleAttributes(
                text: "27.05.20",
                [
                    .paragraph(paragraphStyle),
                    .font(.semibold(15)),
                    .color(.white())
                ]
            )
            $0.lineBreakMode = .byWordWrapping
            $0.numberOfLines = 0
        } layout: {
            $0.centerX.equalTo($1)
            $0.bottom.equalTo($1).offset(-32)
        }
    }
}
