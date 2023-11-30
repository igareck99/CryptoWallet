import SwiftUI

protocol AddSeedRouterable {
    func showStart()
    func importKey(coordinator: ImportKeyCoordinatable)
    func popToRoot()
}

struct AddSeedRouter<
    Content: View,
    State: AddSeedStatable,
    ParentState: WalletRouterStatable,
    Factory: ViewsBaseFactoryProtocol
>: View {

    @ObservedObject var state: State
    @ObservedObject var parentState: ParentState
    let factory: Factory.Type
    let content: () -> Content

    var body: some View {
        NavigationStack(path: $state.path) {
            content()
                .navigationDestination(
                    for: BaseContentLink.self,
                    destination: factory.makeContent
                )
        }
    }
}

// MARK: - AddSeedRouterable

extension AddSeedRouter: AddSeedRouterable {

    func showStart() {
        parentState.presentedItem = BaseSheetLink.addSeed {
            self as? AddSeedRouter<GeneratePhraseView, AddSeedState, WalletRouterState, ViewsBaseFactory>
        }
    }

    func importKey(coordinator: ImportKeyCoordinatable) {
        state.path.append(BaseContentLink.importKey(coordinator: coordinator))
    }

    func popToRoot() {
        parentState.presentedItem = nil
        DispatchQueue.main.async {
            self.state.path = NavigationPath()
            self.state.presentedItem = nil
        }
    }
}
