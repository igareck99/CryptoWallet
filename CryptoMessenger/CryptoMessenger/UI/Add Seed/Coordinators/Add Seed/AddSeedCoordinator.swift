import Foundation
import SwiftUI

protocol AddSeedCoordinatable: Coordinator {
    func showImportKey()
}

final class AddSeedCoordinator<RootRouter: AddSeedRootRouterable> {

    var childCoordinators = [String: Coordinator]()
    private var router: GeneratePhraseRouterable?
    private let rootRouter: RootRouter
    private let onFinish: (Coordinator) -> Void

    init(
        rootRouter: RootRouter,
        onFinish: @escaping (Coordinator) -> Void
    ) {
        self.rootRouter = rootRouter
        self.onFinish = onFinish
    }

    func finishFlow() {
        rootRouter.popToRoot()
        DispatchQueue.main.async {
            self.onFinish(self)
        }
    }
}

// MARK: - AddSeedCoordinatable

extension AddSeedCoordinator: AddSeedCoordinatable {

    func start() {
        rootRouter.showStart(coordinator: self)
    }

    func showImportKey() {
        router?.importKey(coordinator: self)
    }
}

// MARK: - ImportKeyCoordinatable

extension AddSeedCoordinator: ImportKeyCoordinatable {
    func didImportKey() {
        finishFlow()
    }
}

// MARK: - PhraseGeneratable

extension AddSeedCoordinator: PhraseGeneratable {
    func onImportTap() {
        router?.importKey(coordinator: self)
    }

    func update(router: GeneratePhraseRouterable) {
        self.router = router
    }
}

// MARK: - WatchKeyViewModelDelegate

extension AddSeedCoordinator: WatchKeyViewModelDelegate {
    func didFinishShowPhrase() {
        finishFlow()
    }

    func showPhrase(seed: String) {
        router?.showPhrase(
            seed: seed,
            coordinator: self
        )
    }
}

// MARK: - WarningViewModelDelegate

extension AddSeedCoordinator: WarningViewModelDelegate {
    func showSeedPhrase(seed: String) {
        router?.showPhrase(
            seed: seed,
            coordinator: self
        )
    }

    func cancelCreation() {
        finishFlow()
    }
}
