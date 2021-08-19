import SwiftUI
import UIKit

// MARK: - KeyboardObserver

final class KeyboardObserver {

    // MARK: - Internal Properties

    var keyboardWillShowHandler: NotificationBlock?
    var keyboardWillHideHandler: NotificationBlock?

    // MARK: - Private Properties

    private let targetScroll: UIScrollView?

    // MARK: - Lifecycle

    init(_ targetScroll: UIScrollView? = nil) {
        self.targetScroll = targetScroll
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: - Private Methods

    @objc private func keyboardWillShow(notification: NSNotification) {
        guard
            let userInfo = notification.userInfo,
            let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        else {
            return
        }
        targetScroll?.contentInset.bottom = keyboardFrame.size.height
        keyboardWillShowHandler?(notification)
    }

    @objc private func keyboardWillHide(notification: NSNotification) {
        targetScroll?.contentInset = .zero
        keyboardWillHideHandler?(notification)
    }
}
