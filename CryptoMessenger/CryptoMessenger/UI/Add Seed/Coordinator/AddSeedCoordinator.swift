import Foundation

protocol AddSeedCoordinatable: Coordinator {
    func showImportKey()
}

final class AddSeedCoordinator<Router: AddSeedRouterable> {

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
}

// MARK: - AddSeedCoordinatable

extension AddSeedCoordinator: AddSeedCoordinatable {

    func start() {
        router.showStart()
    }

    func showImportKey() {
        router.importKey(coordinator: self)
    }
}

// MARK: - ImportKeyCoordinatable

extension AddSeedCoordinator: ImportKeyCoordinatable {
    func didImportKey() {
        router.popToRoot()
        DispatchQueue.main.async {
            self.onFinish(self)
        }
    }
}

// MARK: - PhraseGeneratable

extension AddSeedCoordinator: PhraseGeneratable {
    func onImportTap() {
        router.importKey(coordinator: self)
    }
}
