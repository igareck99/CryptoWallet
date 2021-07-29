import UIKit

// MARK: - TapAnimator

final class TapAnimator {

    // MARK: - Private Properties

    private var counter = 0
    private weak var view: UIView?

    // MARK: - Internal Methods

    func start(view: UIView) {
        self.view = view
        counter = 0

        UIView.animate(
            withDuration: 0.1,
            delay: 0,
            options: [.curveEaseIn],
            animations: { view.transform = CGAffineTransform(scaleX: 0.95, y: 0.95) }
        )
        delay(0.11) { [weak self] in
            self?.finish()
        }
    }

    func finish() {
        counter += 1
        if counter < 2 { return }
        UIView.animate(
            withDuration: 0.1,
            delay: 0,
            options: [.curveEaseOut],
            animations: { [weak self] in self?.view?.transform = .identity },
            completion: { [weak self] _ in self?.view?.transform = .identity }
        )
    }
}
