import Combine
import Foundation
import UIKit

final class KeyboardHandler: NSObject, ObservableObject {

    @Published var keyboardHeight = CGFloat(0)

    var spaceBetweenKeyboardAndInputField = CGFloat(20)
    var actualKeyboardHeight: CGFloat?
    var panRecognizer: UIPanGestureRecognizer?
    var subscriptions = Set<AnyCancellable>()

    override init() {
        super.init()
        let panRecognizer = UIPanGestureRecognizer(
            target: self, action: #selector(handlePan))
        panRecognizer.delegate = self
        self.panRecognizer = panRecognizer

        UIApplication.shared.windows.first?
            .addGestureRecognizer(panRecognizer)

        let willShow = NotificationCenter.default.publisher(for: UIApplication.keyboardWillShowNotification)
            .map { $0.keyboardHeight }

        let willHide = NotificationCenter.default.publisher(for: UIApplication.keyboardWillHideNotification)
            .map { _ in CGFloat(0) }

        Publishers.MergeMany(willShow, willHide)
            .sink { [weak self] height in
                self?.keyboardHeight = height
                self?.actualKeyboardHeight = height
            }
            .store(in: &subscriptions)
    }

    @objc private func handlePan(_ gestureRecognizer: UIPanGestureRecognizer) {
        guard
            let window = UIApplication.shared.windows.first,
            let actualKbHeight = actualKeyboardHeight
        else {
            return
        }
        let originY = gestureRecognizer.location(in: window).y
        let screenHeight = UIScreen.main.bounds.height
        guard originY >= screenHeight - actualKbHeight else { return }

        keyboardHeight = screenHeight - originY
    }
}

extension KeyboardHandler: UIGestureRecognizerDelegate {
    func gestureRecognizer(
        _ gestureRecognizer: UIGestureRecognizer,
        shouldReceive touch: UITouch
    ) -> Bool {
        let point = touch.location(in: gestureRecognizer.view)
        var view = gestureRecognizer.view?.hitTest(point, with: nil)
        while let candidate = view {
            if let scrollView = candidate as? UIScrollView {
                scrollView.keyboardDismissMode = .interactive
                return true
            }
            view = candidate.superview
        }
        return false
    }

    func gestureRecognizer(
        _ gestureRecognizer: UIGestureRecognizer,
        shouldRecognizeSimultaneouslyWith
        otherGestureRecognizer: UIGestureRecognizer
    ) -> Bool {
        gestureRecognizer === panRecognizer
    }
}