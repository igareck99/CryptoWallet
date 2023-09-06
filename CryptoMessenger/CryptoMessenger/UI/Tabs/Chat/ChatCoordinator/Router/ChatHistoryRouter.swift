import Foundation
import SwiftUI

// MARK: - ChatHistoryRouter

struct ChatHistoryRouter<Content: View, State: ChatHistoryCoordinatorBase>: View {

    // MARK: - Internal Properties

    @ObservedObject var state: State
    let content: () -> Content

    var body: some View {
        NavigationStack(path: $state.path) {
            ZStack {
                content()
                    .sheet(item: $state.presentedItem, content: sheetContent)
                    .fullScreenCover(item: $state.coverItem, content: fullScreenSheetContent)
            }
            .navigationDestination(
                for: ChatHistoryContentLink.self,
                destination: linkDestination
            )
        }
    }
}
