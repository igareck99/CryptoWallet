import Foundation
import SwiftUI

struct VideoItem: Identifiable, Equatable, Hashable, ViewGeneratable {
    let id = UUID()
    let date: String
    let url: URL
    let reactionItems: [ReactionTextsItem]
    let readStatus: EventStatus
    let onTap: () -> Void

    // MARK: - ViewGeneratable

    func view() -> AnyView {
        EmptyView().anyView()
    }
}
