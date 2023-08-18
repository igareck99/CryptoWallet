import Foundation
import SwiftUI

struct ReplyItem: Identifiable, Equatable, Hashable, ViewGeneratable {
    let id = UUID()
    let date: String
    let repliedItemId: String
    let text: String
    let reactionItems: [ReactionTextsItem]
    let readStatus: EventStatus
    let onTap: () -> Void
    let onReplyTap: () -> Void
    
    // MARK: - ViewGeneratable
    
    func view() -> AnyView {
        EmptyView().anyView()
    }
}
