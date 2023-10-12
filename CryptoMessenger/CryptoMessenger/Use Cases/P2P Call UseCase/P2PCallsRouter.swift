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
		guard let controller = callController else {
            return
        }
        controller.dismissChildViewCont()

        // Ручное удаление контроллера, пока оставил, может понадобится
/*
        // Notify Child View Controller
        controller.willMove(toParent: nil)
        controller.beginAppearanceTransition(false, animated: true)
        // Remove Child View From Superview
        controller.view.removeFromSuperview()
        // Notify Child View Controller
        controller.removeFromParent()
*/
		callController = nil
	}

	func showCallView(
		model: P2PCall,
		p2pCallUseCase: P2PCallUseCaseProtocol
	) {
        guard let rController = rootController else { return }
		let controller = P2PCallsAssembly.build(model: model, p2pCallUseCase: p2pCallUseCase)
		callController = controller
        controller.presentToParentViewController(parent: rController)

        // Ручное добавление контроллера, пока оставил, может понадобится
/*
        // Add Child View Controller
        rootController?.addChild(controller)
        controller.beginAppearanceTransition(true, animated: true)
        // Add Child View as Subview
        rootController?.view.addSubview(controller.view)
        // Configure Child View
        controller.view.frame = rootController?.view.bounds ?? CGRect.zero
        controller.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        // Notify Child View Controller
        controller.didMove(toParent: rootController)
*/
	}
}

extension UIViewController {
    func presentToParentViewController(parent: UIViewController) {
        parent.addChild(self)
        parent.view.addSubview(self.view)
        self.view.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        self.view.transform = CGAffineTransform(translationX: parent.view.bounds.width, y: 0)
        UIView.animate(withDuration: 0.28, delay: 0.1, options: .curveEaseInOut, animations: {
            self.view.transform = CGAffineTransform(translationX: 0, y: 0)
        }, completion: { _ in
            self.didMove(toParent: parent)
        })
    }
    func dismissChildViewCont() {
        willMove(toParent: nil)
        self.view.transform = CGAffineTransform(translationX: 0, y: 0)
        UIView.animate(withDuration: 0.28, delay: 0.1, options: .curveEaseInOut, animations: {
            self.view.transform = CGAffineTransform(translationX: self.view.bounds.width, y: 0)
        }, completion: { _ in
            self.view.removeFromSuperview()
            self.removeFromParent()
        })
    }
}
