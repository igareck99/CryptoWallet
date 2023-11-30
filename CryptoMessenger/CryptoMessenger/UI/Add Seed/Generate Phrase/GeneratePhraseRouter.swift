import SwiftUI

protocol GeneratePhraseRouterable {
    func importKey(coordinator: ImportKeyCoordinatable)
    func showPhrase(
        seed: String,
        coordinator: WatchKeyViewModelDelegate
    )
}

struct GeneratePhraseRouter<
    Content: View,
    State: GeneratePhraseStatable,
    Factory: ViewsBaseFactoryProtocol
>: View {

    @ObservedObject var state: State
    let factory: Factory.Type
    let content: () -> Content

    var body: some View {
        NavigationStack(path: $state.path) {
            content()
                .sheet(
                    item: $state.presentedItem,
                    content: factory.makeSheet
                )
                .navigationDestination(
                    for: BaseContentLink.self,
                    destination: factory.makeContent
                )
        }
    }
}

// MARK: - GeneratePhraseRouterable

extension GeneratePhraseRouter: GeneratePhraseRouterable {

    func navState() -> State {
        state
    }

    func routePath() -> Binding<NavigationPath> {
        $state.path
    }

    func previousScreen() {
        state.path.removeLast()
    }

    func presentedItem() -> Binding<BaseSheetLink?> {
        $state.presentedItem
    }

    func popToRoot() {
        state.path = NavigationPath()
        state.presentedItem = nil
    }

    func importKey(coordinator: ImportKeyCoordinatable) {
        state.path.append(BaseContentLink.importKey(coordinator: coordinator))
    }

    func showPhrase(
        seed: String,
        coordinator: WatchKeyViewModelDelegate
    ) {
        state.path.append(
            BaseContentLink.showPhrase(
                seed: seed,
                coordinator: coordinator
            )
        )
    }
}
