import SwiftUI

protocol AddSeedRootRouterable {
    func showStart(coordinator: PhraseGeneratable)
    func importKey(coordinator: ImportKeyCoordinatable)
    func popToRoot()
}

final class AddSeedRootRouter<State: AddSeedRootStatable> {

    @Published var state: State

    init(state: State) {
        self.state = state
    }
}

// MARK: - AddSeedRootRouterable

extension AddSeedRootRouter: AddSeedRootRouterable {
    func showStart(coordinator: PhraseGeneratable) {
        state.presentedItem = BaseSheetLink.addSeed(coordinator: coordinator)
    }

    func importKey(coordinator: ImportKeyCoordinatable) {
        state.path.append(BaseContentLink.importKey(coordinator: coordinator))
    }

    func popToRoot() {
        state.presentedItem = nil
        DispatchQueue.main.async {
            self.state.presentedItem = nil
            self.state.path = NavigationPath()
        }
    }

    func previousScreen() {
        state.path.removeLast()
    }
}
