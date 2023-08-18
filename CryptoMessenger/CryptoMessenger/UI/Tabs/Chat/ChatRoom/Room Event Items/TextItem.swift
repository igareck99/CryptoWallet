import Foundation
import SwiftUI

struct TextItem: Identifiable, Equatable, Hashable, ViewGeneratable {
    let id = UUID()
    let date: String
    let text: String
    let reactionItems: [ReactionTextsItem]
    let readStatus: EventStatus
    let onTap: () -> Void

    // MARK: - ViewGeneratable

    func view() -> AnyView {
        EmptyView().anyView()
    }
}
