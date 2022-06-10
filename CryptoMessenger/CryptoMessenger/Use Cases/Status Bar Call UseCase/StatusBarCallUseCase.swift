import UIKit

final class StatusBarCallUseCase {

	private var isCallEnded = false

	private var underStatusView: StatusBarCallView?

	init(appWindow: UIWindow) {
		configureViews(appWindow: appWindow)
		configureNotifications()
	}

	private func configureViews(appWindow: UIWindow) {
		underStatusView = StatusBarCallView(
			appWindow: appWindow,
			delegate: self
		)
	}

	private func configureNotifications() {
		NotificationCenter.default.addObserver(
			self,
			selector: #selector(didReceiveCallStart(notification:)),
			name: .callDidStart,
			object: nil
		)

		NotificationCenter.default.addObserver(
			self,
			selector: #selector(didReceiveCallEnd(notification:)),
			name: .callDidEnd,
			object: nil
		)

		NotificationCenter.default.addObserver(
			self,
			selector: #selector(didReceiveCallViewDidAppear(notification:)),
			name: .callViewDidAppear,
			object: nil
		)

		NotificationCenter.default.addObserver(
			self,
			selector: #selector(didReceiveCallViewWillAppear(notification:)),
			name: .callViewWillAppear,
			object: nil
		)

		NotificationCenter.default.addObserver(
			self,
			selector: #selector(didReceiveCallViewDisappear(notification:)),
			name: .callViewDidDisappear,
			object: nil
		)
	}

	@objc func didReceiveCallStart(notification: Notification) {
		debugPrint("didReceiveCallStart")
		isCallEnded = false
		animateStatusView(show: true)
	}

	@objc func didReceiveCallEnd(notification: Notification) {
		debugPrint("didReceiveCallEnd")
		isCallEnded = true
		animateStatusView(show: false)
	}

	@objc func didReceiveCallViewDidAppear(notification: Notification) {
		debugPrint("didReceiveCallViewDidAppear")
		animateStatusView(show: false)
	}

	@objc func didReceiveCallViewWillAppear(notification: Notification) {
		debugPrint("didReceiveCallViewWillAppear")
	}

	@objc func didReceiveCallViewDisappear(notification: Notification) {
		debugPrint("didReceiveCallViewDisappear")
		if !isCallEnded {
			animateStatusView(show: true)
		}
	}

	private func animateStatusView(show: Bool) {
		self.underStatusView?.coloredViewHeightConstraint?.constant = show ? 30 : 0
		self.underStatusView?.heightConstraint?.constant = show ? 50 : 0
	}
}

extension StatusBarCallUseCase {
	func configure(
		window: UIWindow,
		rootViewController: UIViewController
	) {
		rootViewController.view.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			rootViewController.view.leadingAnchor.constraint(equalTo: window.leadingAnchor),
			rootViewController.view.trailingAnchor.constraint(equalTo: window.trailingAnchor),
			rootViewController.view.bottomAnchor.constraint(equalTo: window.bottomAnchor)
		])
	}
}

// MARK: - StatusBarCallViewDelegate

extension StatusBarCallUseCase: StatusBarCallViewDelegate {

	func didTapCallStatusView() {
		NotificationCenter.default.post(
			name: .statusBarTapped,
			object: nil
		)
	}
}
