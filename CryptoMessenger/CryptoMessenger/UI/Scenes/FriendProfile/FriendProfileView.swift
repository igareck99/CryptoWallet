import UIKit

// MARK: - FriendProfileView

final class FriendProfileView: UIView {

    // MARK: - Internal Properties

    var didTap: (() -> Void)?

    // MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
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
