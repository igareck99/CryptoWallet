import SwiftUI

enum TabItemsViewAssembly {
    static func build() -> some View {
        let viewModel = TabItemsViewModel(
            toggles: MainFlowTogglesFacade.shared,
            factory: TabItemsFactory.self
        )
        let view = TabItemsView(viewModel: viewModel)
        return view
    }
}
