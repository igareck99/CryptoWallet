import UIKit

// Включает жест обратного свайпа для ухода с экрана при .navigationBarBackButtonHidden(true)
extension UINavigationController: UIGestureRecognizerDelegate {
	override open func viewDidLoad() {
		super.viewDidLoad()
		interactivePopGestureRecognizer?.delegate = self
	}

	public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
		return viewControllers.count > 1
	}

	public func gestureRecognizer(
		_ gestureRecognizer: UIGestureRecognizer,
		shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer
	) -> Bool {
		true
	}
}
