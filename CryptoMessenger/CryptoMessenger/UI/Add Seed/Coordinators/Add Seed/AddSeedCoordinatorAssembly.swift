import SwiftUI

enum AddSeedCoordinatorAssembly {
    static func build(
        path: Binding<NavigationPath>,
        presentedItem: Binding<BaseSheetLink?>,
        onFinish: @escaping (Coordinator) -> Void
    ) -> Coordinator {
        let state = AddSeedRootState(
            path: path,
            presentedItem: presentedItem
        )
        let rootRouter = AddSeedRootRouter(state: state)
        let coordinator = AddSeedCoordinator(
            rootRouter: rootRouter,
            onFinish: onFinish
        )
        return coordinator
    }
}
