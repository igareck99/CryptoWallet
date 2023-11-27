import Foundation
import SwiftUI

// MARK: - ChatHistoryRouter

struct ChatHistoryRouter<
    Content: View,
    State: ChatHistoryCoordinatorBase,
    Factory: ViewsBaseFactoryProtocol
>: View {

    // MARK: - Internal Properties

    @ObservedObject var state: State
    let factory: Factory.Type
    let content: () -> Content

    var body: some View {
        NavigationStack(path: $state.path) {
            ZStack {
                content()
                    .sheet(
                        item: $state.presentedItem,
                        content: factory.makeSheet
                    )
                    .fullScreenCover(
                        item: $state.coverItem,
                        content: factory.makeFullCover
                    )
            }
            .navigationDestination(
                for: BaseContentLink.self,
                destination: factory.makeContent
            )
        }
    }
}
