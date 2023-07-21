import UIKit
import SwiftUI

protocol P2PCallsRouterable {

	var isCallViewControllerBeingPresented: Bool { get }

	func removeCallController()

	func showCallView(
		model: P2PCall,
		p2pCallUseCase: P2PCallUseCaseProtocol
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
        /*
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
         */
        AppNavStackState.shared.path = NavigationPath()
	}

	func showCallView(
		model: P2PCall,
		p2pCallUseCase: P2PCallUseCaseProtocol
	) {
        AppNavStackState.shared.path.append(AppTransitions.callView(model: model, p2pCallUseCase: p2pCallUseCase))
//		let view = P2PCallsAssembly.make(model: model, p2pCallUseCase: p2pCallUseCase)
//		callController = controller
//		navigationController?.pushViewController(controller, animated: true)
	}

	func showCallView(
		model: P2PCall,
		p2pCallUseCase: P2PCallUseCaseProtocol,
		completion: @escaping () -> Void
	) {
		transitionCompletion = completion
		let controller = P2PCallsAssembly.build(model: model, p2pCallUseCase: p2pCallUseCase)
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
