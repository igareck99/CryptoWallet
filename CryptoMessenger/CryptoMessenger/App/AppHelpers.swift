import UIKit

// MARK: - Types

typealias VoidBlock = () -> Void
typealias GenericBlock<T> = (T) -> Void
typealias StringBlock = (String) -> Void
typealias NotificationBlock = (NSNotification) -> Void

// MARK: - Internal Methods

func delay(_ delay: Double, closure: @escaping VoidBlock) {
    let when: DispatchTime = .now() + delay
    DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
}

func vibrate(_ style: UIImpactFeedbackGenerator.FeedbackStyle = .light) {
    UIImpactFeedbackGenerator(style: style).impactOccurred()
}
