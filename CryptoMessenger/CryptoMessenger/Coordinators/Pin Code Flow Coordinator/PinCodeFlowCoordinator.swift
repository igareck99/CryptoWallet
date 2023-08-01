import UIKit
import SwiftUI

// MARK: - PinCodeFlowCoordinatorDelegate

protocol PinCodeFlowCoordinatorDelegate: AnyObject {
    func userApprovedAuthentication(coordinator: Coordinator)
}

// MARK: - PinCodeFlowCoordinatorSceneDelegate

protocol PinCodeFlowCoordinatorSceneDelegate: AnyObject {
    func switchFlow()
}

// MARK: - PinCodeFlowCoordinator

public final class PinCodeFlowCoordinator: Coordinator {

    // MARK: - Internal Properties

    var childCoordinators: [String: Coordinator] = [:]
    weak var delegate: PinCodeFlowCoordinatorDelegate?
    private let userFlows: UserFlowsStorage
    var renderView: (any View) -> Void
    var onLogin: () -> Void

    // MARK: - Lifecycle

    init(
        userFlows: UserFlowsStorage,
        renderView: @escaping (any View) -> Void,
        onLogin: @escaping () -> Void
    ) {
        self.userFlows = userFlows
        self.onLogin = onLogin
        self.renderView = renderView
    }

    // MARK: - Internal Methods

    func start() {
        showPinCodeScene()
    }
    
    // MARK: - Private Methods

    private func showPinCodeScene() {
        let view = PinCodeAssembly.build(screenType: .login, onLogin: {
            NotificationCenter.default.post(name: .userDidLoggedIn, object: nil)
            self.onLogin()
        })
        self.renderView(view)
    }
}

// MARK: - PinCodeFlowCoordinator (PinCodeFlowCoordinatorSceneDelegate)

extension PinCodeFlowCoordinator: PinCodeFlowCoordinatorSceneDelegate {
    func switchFlow() {
        delegate?.userApprovedAuthentication(coordinator: self)
    }
}

// MARK: - PinCodeFlowCoordinator (PinCodeSceneDelegate)

extension PinCodeFlowCoordinator: PinCodeSceneDelegate {
    
    func handleNextScene() {
        switchFlow()
    }
}
