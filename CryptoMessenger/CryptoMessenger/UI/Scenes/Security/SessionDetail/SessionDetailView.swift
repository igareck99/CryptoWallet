import UIKit

// MARK: - SessionDetailView

final class SessionDetailView: UIView {

    // MARK: - Internal Properties

    var didTap: VoidBlock?

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

    func publicMethod() {

    }

    // MARK: - Private Methods

    private func setup() {

    }
}
