import UIKit

protocol P2PCallsRouterable {

	var isCallViewControllerBeingPresented: Bool { get }

	func removeCallController()

	func showCallView(
		model: P2PCall,
		p2pCallUseCase: P2PCallUseCaseProtocol
	)
}

final class P2PCallsRouter: NSObject {
	private weak var callController: UIViewController?
    private var rootController: UIViewController? {
        guard let scene = UIApplication.shared.connectedScenes.first?.delegate as? AppSceneDelegate else {
            return nil
        }
        return scene.upWindow?.rootViewController
    }
}

// MARK: - P2PCallsRouterable

extension P2PCallsRouter: P2PCallsRouterable {

	var isCallViewControllerBeingPresented: Bool {
		callController != nil
	}

	func removeCallController() {
        guard let rootNavController = rootController as? UINavigationController else { return }
        rootNavController.popToRootViewController(animated: true)
	}

	func showCallView(
		model: P2PCall,
		p2pCallUseCase: P2PCallUseCaseProtocol
	) {
        guard let rootNavController = rootController as? UINavigationController else { return }
		let controller = P2PCallsAssembly.build(model: model, p2pCallUseCase: p2pCallUseCase)
		callController = controller
        rootNavController.pushViewController(controller, animated: true)
	}
}
