import UIKit

final class StatusBarCallUseCase {
    static let shared = StatusBarCallUseCase()
	private var isCallEnded = false
	private var underStatusView: StatusBarCallViewProtocol?
    private var aboveStatusView: StatusBarCallViewProtocol?
    weak var appWindow: UIWindow?
    weak var upperWindow: UIWindow?

    var underStatusViewRect: CGRect {
        underStatusView?.rect ?? .zero
    }

    var aboveStatusViewRect: CGRect {
        aboveStatusView?.rect ?? .zero
    }

	init() {
		configureNotifications()
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
        debugPrint("animateStatusView(show: \(show)")
		underStatusView?.animateStatusView(show: show)
        aboveStatusView?.animateStatusView(show: show)
	}
}

extension StatusBarCallUseCase {

	func configure(window: UIWindow) {
        guard appWindow == nil else { return }
        guard let rootViewController = window.rootViewController else {
            return
        }
        self.appWindow = window
        underStatusView = StatusBarCallView(
            appWindow: window,
            delegate: self
        )

		rootViewController.view.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			rootViewController.view.leadingAnchor.constraint(equalTo: window.leadingAnchor),
			rootViewController.view.trailingAnchor.constraint(equalTo: window.trailingAnchor),
			rootViewController.view.bottomAnchor.constraint(equalTo: window.bottomAnchor)
		])
	}

    func configure(upWindow: UIWindow) {
        guard upperWindow == nil else { return }
        guard let rootViewController = upWindow.rootViewController else {
            return
        }
        self.upperWindow = upWindow
        aboveStatusView = StatusBarCallView(
            appWindow: upWindow,
            delegate: self
        )

        rootViewController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            rootViewController.view.leadingAnchor.constraint(equalTo: upWindow.leadingAnchor),
            rootViewController.view.trailingAnchor.constraint(equalTo: upWindow.trailingAnchor),
            rootViewController.view.bottomAnchor.constraint(equalTo: upWindow.bottomAnchor)
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
