import UIKit

class SPView: UIView {

    // MARK: - Internal Properties

    var didTapDelete: (() -> Void)?

    // MARK: - Private Properties
    private lazy var brushButton = UIButton()
    private lazy var clearButton = UIButton()

    // MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        background(.white())
        setupbrushButton()
        setupClearLabel()

    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("not implemented")
    }

    // MARK: - Internal Methods

    @objc private func deleteButtonTap() {
        print("deleteCalls")
        didTapDelete?()
    }

    // MARK: - Private Methods

    private func setupbrushButton() {
        brushButton.snap(parent: self) {
            $0.setImage(R.image.callList.brush(), for: .normal)
            $0.clipCorners(radius: 20)
            $0.background(.red(0.1))
            $0.addTarget(self, action: #selector(self.deleteButtonTap), for: .touchUpInside)
        } layout: {
            $0.width.height.equalTo(40)
            $0.top.equalTo(self.snp_topMargin).offset(28)
            $0.leading.equalTo($1).offset(16)
        }
    }

    private func setupClearLabel() {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.15
        paragraphStyle.alignment = .center
        clearButton.snap(parent: self) {
            $0.titleAttributes(
                text: R.string.localizable.callListDeleteAll(),
                [
                    .paragraph(paragraphStyle),
                    .font(.regular(17)),
                    .color(.red())
                ]
            )
            $0.addTarget(self, action: #selector(self.deleteButtonTap), for: .touchUpInside)
        } layout: {
            $0.top.equalTo(self.snp_topMargin).offset(37)
            $0.leading.equalTo($1).offset(72)
        }

    }

}
