import Foundation

protocol GroupCallsRouterable {
    func showGroupCall(delegate: GroupCallsViewControllerDelegate)
}

final class GroupCallsRouter {
    private var navigationController: UINavigationController? {
        guard let scene = UIApplication.shared.connectedScenes.first?.delegate as? AppSceneDelegate else {
            return nil
        }
        return scene.upWindow?.rootViewController as? UINavigationController
    }
}

// MARK: - GroupCallsRouterable

extension GroupCallsRouter: GroupCallsRouterable {
    
    func showGroupCall(delegate: GroupCallsViewControllerDelegate) {
        let controller = GroupCallsAssembly.build(delegate: delegate)
        navigationController?.pushViewController(controller, animated: true)
    }
}
