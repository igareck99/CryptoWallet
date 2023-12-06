import SwiftUI

protocol CreatePhraseRouterable: ObservableObject {

    func addSeed(coordinator: PhraseGeneratable)

    func importKey(coordinator: ImportKeyCoordinatable)

    func popToRoot()

    func previousScreen()

    func showPhrase(
        seed: String,
        type: WatchKeyViewType,
        coordinator: WatchKeyViewModelDelegate
    )
}

final class CreatePhraseRouter<State: CreatePhraseStatable> {

    @ObservedObject var state: State

    init(state: State) {
        self.state = state
    }
}

// MARK: - CreatePhraseRouterable

extension CreatePhraseRouter: CreatePhraseRouterable {

    func importKey(coordinator: ImportKeyCoordinatable) {
        state.path.append(BaseContentLink.importKey(coordinator: coordinator))
    }

    func addSeed(coordinator: PhraseGeneratable) {
        state.path.append(BaseContentLink.addSeed(coordinator: coordinator))
    }

    func previousScreen() {
        state.path.removeLast()
    }

    func navState() -> State {
        state
    }

    func popToRoot() {
        state.path = NavigationPath()
        state.presentedItem = nil
    }

    func showPhrase(
        seed: String,
        type: WatchKeyViewType,
        coordinator: WatchKeyViewModelDelegate
    ) {
        state.path.append(
            BaseContentLink.showPhrase(
                seed: seed,
                type: type,
                coordinator: coordinator
            )
        )
    }
}
