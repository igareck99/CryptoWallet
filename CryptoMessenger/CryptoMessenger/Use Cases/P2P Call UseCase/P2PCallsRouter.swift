import UIKit

protocol P2PCallsRouterable {

	func removeCallController()

	func showCallView(
		userName: String,
		callType: P2PCallUseCase.CallType,
		callState: P2PCallUseCase.CallState,
		delegate: CallViewControllerDelegate,
		completion: @escaping () -> Void
	)

	func showCallView(
		userName: String,
		p2pCallUseCase: P2PCallUseCase,
		callType: P2PCallUseCase.CallType,
		callState: P2PCallUseCase.CallState,
		delegate: CallViewControllerDelegate
	)
}

final class P2PCallsRouter: NSObject {

	private var transitionCompletion: (() -> Void)?
	private var callController: UIViewController?
	private lazy var navigationController: UINavigationController? = {
		UIApplication.shared.windows.first?.rootViewController as? UINavigationController
	}()
}

// MARK: - P2PCallsRouterable

extension P2PCallsRouter: P2PCallsRouterable {

	func removeCallController() {
		guard let controller = callController,
			  navigationController?.viewControllers.contains(controller) == true else { return }

		if navigationController?.viewControllers.last == controller {
			navigationController?.popViewController(animated: true)
		} else {
			navigationController?.viewControllers.removeAll(where: {
				controller == $0
			})
		}
	}

	func showCallView(
		userName: String,
		p2pCallUseCase: P2PCallUseCase,
		callType: P2PCallUseCase.CallType,
		callState: P2PCallUseCase.CallState,
		delegate: CallViewControllerDelegate
	) {
		let controller = CallViewController(
			userName: userName,
			callState: callState,
			callType: callType,
			delegate: delegate
		)
		callController = controller
		p2pCallUseCase.delegate = controller
		navigationController?.pushViewController(controller, animated: true)
	}

	func showCallView(
		userName: String,
		callType: P2PCallUseCase.CallType,
		callState: P2PCallUseCase.CallState,
		delegate: CallViewControllerDelegate,
		completion: @escaping () -> Void
	) {
		transitionCompletion = completion
		let controller = CallViewController(
			userName: userName,
			callState: callState,
			callType: callType,
			delegate: delegate
		)
		callController = controller
		navigationController?.delegate = self
		navigationController?.pushViewController(controller, animated: true)
	}
}

// MARK: - UINavigationControllerDelegate

extension P2PCallsRouter: UINavigationControllerDelegate {
	func navigationController(
		_ navigationController: UINavigationController,
		didShow viewController: UIViewController,
		animated: Bool
	) {
		transitionCompletion?()
	}
}
