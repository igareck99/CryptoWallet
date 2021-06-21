import UIKit

// MARK: StartView

final class StartView: UIView {

    // MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    // MARK: - Private Methods

    private func commonInit() {
        backgroundColor = .white
    }
}
