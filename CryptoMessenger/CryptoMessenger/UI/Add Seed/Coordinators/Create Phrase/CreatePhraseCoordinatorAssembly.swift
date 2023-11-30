import SwiftUI

enum CreatePhraseCoordinatorAssembly {
    static func build(
        path: Binding<NavigationPath>,
        presentedItem: Binding<BaseSheetLink?>,
        onFinish: @escaping (Coordinator) -> Void
    ) -> Coordinator {
        let state = CreatePhraseState(
            path: path,
            presentedItem: presentedItem
        )
        let router = CreatePhraseRouter(state: state)
        let coordinator = CreatePhraseCoordinator(
            router: router,
            onFinish: onFinish
        )
        return coordinator
    }
}
