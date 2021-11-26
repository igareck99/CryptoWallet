import Combine
import SwiftUI
import UIKit

protocol KeyboardListenable {
    var keyboardPublisher: AnyPublisher<Bool, Never> { get }
    var keyboardHeight: AnyPublisher<CGFloat, Never> { get }
}

extension KeyboardListenable {
    var keyboardPublisher: AnyPublisher<Bool, Never> {
        Publishers.Merge(
            NotificationCenter.default
                .publisher(for: UIResponder.keyboardWillShowNotification)
                .map { _ in true },

            NotificationCenter.default
                .publisher(for: UIResponder.keyboardWillHideNotification)
                .map { _ in false }
        )
        .eraseToAnyPublisher()
    }

    var keyboardHeight: AnyPublisher<CGFloat, Never> {
        NotificationCenter
            .default
            .publisher(for: UIResponder.keyboardWillShowNotification)
            .map { notification in
                if let keyboardFrame: NSValue = notification
                    .userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
                    let keyboardRectangle = keyboardFrame.cgRectValue
                    let keyboardHeight = keyboardRectangle.height
                    return keyboardHeight
                } else {
                    return 0
                }
            }
            .eraseToAnyPublisher()
    }
}

struct HideKeyboardOnTapModifier: ViewModifier {
    var shouldAdd: Bool
    var onTapped: VoidBlock?

    func body(content: Content) -> some View {
        content
            .gesture(shouldAdd ? TapGesture().onEnded { _ in
                resignFirstResponder()
                if let onTapped = onTapped {
                    onTapped()
                }
            } : nil)
    }
}

func resignFirstResponder() {
    UIApplication.shared.sendAction(
        #selector(UIResponder.resignFirstResponder),
        to: nil,
        from: nil,
        for: nil
    )
}
