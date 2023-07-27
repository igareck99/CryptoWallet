import SwiftUI

enum TabItemsViewAssembly {
    static func build(onlogout: @escaping () -> Void) -> some View {
        let viewModel = TabItemsViewModel(
            toggles: MainFlowTogglesFacade.shared,
            factory: TabItemsFactory.self,
            onlogout: onlogout
        )
        let view = TabItemsView(viewModel: viewModel)
        return view
    }
}
