import SwiftUI

enum TabItemsViewAssembly {
    static func build(
        chateDelegate: ChatHistorySceneDelegate,
        profileDelegate: ProfileSceneDelegate
    ) -> some View {
        let viewModel = TabItemsViewModel(
            chateDelegate: chateDelegate,
            profileDelegate: profileDelegate,
            toggles: MainFlowTogglesFacade.shared,
            factory: TabItemsFactory.self
        )
        let view = TabItemsView(viewModel: viewModel)
        return view
    }
}
