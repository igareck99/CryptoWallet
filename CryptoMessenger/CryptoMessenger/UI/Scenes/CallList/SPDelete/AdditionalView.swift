import UIKit

final class AdditionalView: UIView {

    // MARK: - Internal Properties

    var didTapDelete: VoidBlock?

    // MARK: - Private Properties

    private lazy var brushButton = UIButton()
    private lazy var clearButton = UIButton()

    // MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        background(.white())
        setupBrushButton()
        setupClearButton()
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("not implemented")
    }

    // MARK: - Internal Methods

    @objc private func deleteButtonTap() {
        didTapDelete?()
    }

    // MARK: - Private Methods

    private func setupBrushButton() {
        brushButton.snap(parent: self) {
            $0.setImage(R.image.callList.brush(), for: .normal)
            $0.clipCorners(radius: 20)
            $0.background(.lightRed(0.1))
            $0.addTarget(self, action: #selector(self.deleteButtonTap), for: .touchUpInside)
        } layout: {
            $0.width.height.equalTo(40)
            $0.top.equalTo(self.snp_topMargin).offset(18)
            $0.leading.equalTo($1).offset(16)
        }
    }

    private func setupClearButton() {
        clearButton.snap(parent: self) {
            $0.titleAttributes(
                text: R.string.localizable.callListDeleteAll(),
                [
                    .paragraph(.init(lineHeightMultiple: 1.15, alignment: .center)),
                    .font(.regular(17)),
                    .color(.lightRed())
                ]
            )
            $0.addTarget(self, action: #selector(self.deleteButtonTap), for: .touchUpInside)
        } layout: {
            $0.top.equalTo(self.snp_topMargin).offset(27)
            $0.height.equalTo(22)
            $0.leading.equalTo($1).offset(72)
        }
    }
}
