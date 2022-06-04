import UIKit

protocol P2PCallsRouterable {

	var isCallViewControllerBeingPresented: Bool { get }

	func removeCallController()

	func showCallView(
		userName: String,
		p2pCallUseCase: P2PCallUseCaseProtocol,
		callType: P2PCallType,
		callState: P2PCallState
	)
}

final class P2PCallsRouter: NSObject {

	private var transitionCompletion: (() -> Void)?
	private weak var callController: UIViewController?
	private var navigationController: UINavigationController? {
		UIApplication.shared.windows.first(where: { $0.rootViewController != nil })?.rootViewController as? UINavigationController
	}
}

// MARK: - P2PCallsRouterable

extension P2PCallsRouter: P2PCallsRouterable {

	var isCallViewControllerBeingPresented: Bool {
		callController != nil
	}

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

		callController = nil
	}

	func showCallView(
		userName: String,
		p2pCallUseCase: P2PCallUseCaseProtocol,
		callType: P2PCallType,
		callState: P2PCallState
	) {
		let controller = P2PCallsAssembly.build(userName: userName, p2pCallUseCase: p2pCallUseCase)
		callController = controller
		navigationController?.pushViewController(controller, animated: true)
	}

	func showCallView(
		userName: String,
		p2pCallUseCase: P2PCallUseCaseProtocol,
		callType: P2PCallType,
		callState: P2PCallState,
		completion: @escaping () -> Void
	) {
		transitionCompletion = completion
		let controller = P2PCallsAssembly.build(userName: userName, p2pCallUseCase: p2pCallUseCase)
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
