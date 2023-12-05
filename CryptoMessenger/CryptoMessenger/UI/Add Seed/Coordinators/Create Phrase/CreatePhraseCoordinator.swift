import Foundation
import SwiftUI

final class CreatePhraseCoordinator<Router: CreatePhraseRouterable> {

    var childCoordinators = [String: Coordinator]()
    private let router: Router
    private let onFinish: (Coordinator) -> Void

    init(
        router: Router,
        onFinish: @escaping (Coordinator) -> Void
    ) {
        self.router = router
        self.onFinish = onFinish
    }

    func finishFlow() {
        router.popToRoot()
        onFinish(self)
    }
}

// MARK: - Coordinator

extension CreatePhraseCoordinator: Coordinator {

    func start() {
        router.addSeed(coordinator: self)
    }
}

// MARK: - ImportKeyCoordinatable

extension CreatePhraseCoordinator: ImportKeyCoordinatable {
    func didImportKey() {
        finishFlow()
    }
}

// MARK: - PhraseGeneratable

extension CreatePhraseCoordinator: PhraseGeneratable {
    func onImportTap() {
        router.importKey(coordinator: self)
    }
}

// MARK: - WatchKeyViewModelDelegate

extension CreatePhraseCoordinator: WatchKeyViewModelDelegate {
    func didFinishShowPhrase() {
        finishFlow()
    }

    func showPhrase(seed: String) {
        router.showPhrase(
            seed: seed,
            type: .endOfSeedCreation,
            coordinator: self
        )
    }
}

// MARK: - WarningViewModelDelegate

extension CreatePhraseCoordinator: WarningViewModelDelegate {
    func showSeedPhrase(seed: String) {
        router.showPhrase(
            seed: seed,
            type: .endOfSeedCreation,
            coordinator: self
        )
    }

    func cancelCreation() {
        finishFlow()
    }
}
