import SwiftUI

protocol AddSeedRouterable {
    func showStart()
    func importKey(coordinator: ImportKeyCoordinatable)
    func popToRoot()
}

struct AddSeedRouter<
    Content: View,
    State: AddSeedStatable,
    ParentState: WalletRouterStatable
>: View {

    @ObservedObject var state: State
    @ObservedObject var parentState: ParentState

    let content: () -> Content

    var body: some View {
        NavigationStack(path: $state.path) {
            content()
                .navigationDestination(
                    for: AddSeedContentLink.self,
                    destination: linkDestination
                )
        }
    }

    @ViewBuilder
    private func linkDestination(link: AddSeedContentLink) -> some View {
        switch link {
        case let .importKey(coordinator):
            ImportKeyViewAssembly.build(coordinator: coordinator)
        }
    }
}

// MARK: - AddSeedRouterable

extension AddSeedRouter: AddSeedRouterable {

    func showStart() {
        parentState.presentedItem = BaseSheetLink.addSeed {
            self as? AddSeedRouter<GeneratePhraseView, AddSeedState, WalletRouterState>
        }
    }

    func importKey(coordinator: ImportKeyCoordinatable) {
        state.path.append(AddSeedContentLink.importKey(coordinator: coordinator))
    }

    func popToRoot() {
        parentState.presentedItem = nil
        DispatchQueue.main.async {
            self.state.path = NavigationPath()
            self.state.presentedItem = nil
        }
    }
}
