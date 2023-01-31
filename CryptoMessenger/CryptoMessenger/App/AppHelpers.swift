import UIKit

// MARK: - Types

typealias EmptyFailureBlock<K> = (EmptyFailureResult<K>) -> Void
typealias EmptyResultBlock = (EmptyResult) -> Void
typealias VoidBlock = () -> Void
typealias GenericBlock<T> = (T) -> Void
typealias StringBlock = (String) -> Void
typealias NotificationBlock = (NSNotification) -> Void

// MARK: - Global Methods

func delay(_ delay: Double, closure: @escaping VoidBlock) {
    let when: DispatchTime = .now() + delay
    DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
}

func vibrate(_ style: UIImpactFeedbackGenerator.FeedbackStyle = .light) {
    UIImpactFeedbackGenerator(style: style).impactOccurred()
}

enum EmptyResult {

	case success
	case failure

	var isSuccess: Bool { !isFailure }

	var isFailure: Bool {
		guard case .failure = self else { return false }
		return true
	}
}

enum EmptyFailureResult<T> {
	case success(T)
	case failure
}
