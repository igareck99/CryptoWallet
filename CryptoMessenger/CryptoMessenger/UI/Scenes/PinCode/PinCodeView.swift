import UIKit

// MARK: - PinCodeView

final class PinCodeView: UIView {

    // MARK: - Internal Properties

    var didTap: (() -> Void)?

    // MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        background(.white())
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("not implemented")
    }

    // MARK: - Internal Methods

    func internalMethod() {

    }

    // MARK: - Private Methods

    private func privateMethod() {

    }
}
