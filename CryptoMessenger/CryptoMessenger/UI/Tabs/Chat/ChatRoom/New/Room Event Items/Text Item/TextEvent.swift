import SwiftUI

struct TextEvent: Identifiable, ViewGeneratable {
    let id = UUID()
    let userId: String
    let isFromCurrentUser: Bool
    let avatarUrl: URL?
    let text: String
    let isReply: Bool
    let replyDescription: String
    let width: CGFloat
    let eventData: any ViewGeneratable
    let reactionsGrid: any ViewGeneratable

    // MARK: - ViewGeneratable

    func view() -> AnyView {
        TextEventView(
            model: self,
            eventData: eventData.view(),
            reactions: reactionsGrid.view()
        )
        .anyView()
    }
}
