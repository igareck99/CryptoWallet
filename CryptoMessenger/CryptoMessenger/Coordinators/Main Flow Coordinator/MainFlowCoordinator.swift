import SwiftUI
import UIKit

// MARK: - MainFlowCoordinatorDelegate

protocol MainFlowCoordinatorDelegate: AnyObject {
    func userPerformedLogout(coordinator: Coordinator)
	func didEndStartProcess(coordinator: Coordinator)
}

// MARK: - MainFlowCoordinator

final class MainFlowCoordinator: Coordinator {

    // MARK: - Internal Properties

    var childCoordinators: [String: Coordinator] = [:]
    weak var delegate: MainFlowCoordinatorDelegate?
    var renderView: RootViewBuilder
    private let togglesFacade: MainFlowTogglesFacadeProtocol
    private let onlogout: () -> Void

    // MARK: - Lifecycle

    init(
        togglesFacade: MainFlowTogglesFacadeProtocol,
        renderView: @escaping RootViewBuilder,
        onlogout: @escaping () -> Void
    ) {
        self.togglesFacade = togglesFacade
        self.renderView = renderView
        self.onlogout = onlogout
    }

    // MARK: - Internal Methods

    func start() {
        makeTabBarView()
    }

    func makeTabBarView() {
        let view = TabItemsViewAssembly.build(onlogout: onlogout)
        renderView(view)
    }
}
