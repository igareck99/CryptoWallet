import Foundation
import SwiftUI

// MARK: - ChatHistoryRouter

struct ChatHistoryRouter<Content: View, State: ChatHistoryCoordinatorBase>: View {

    // MARK: - Internal Properties
    private let factory = ViewsBaseFactory.self
    @ObservedObject var state: State
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
