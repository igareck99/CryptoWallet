import Foundation
import SwiftUI

struct ContactItem: Identifiable, Equatable, Hashable, ViewGeneratable {
    let id = UUID()
    let date: String
    let contact: Contact
    let reactionItems: [ReactionTextsItem]
    let readStatus: EventStatus
    let onTap: () -> Void
    
    // MARK: - ViewGeneratable
    
    func view() -> AnyView {
        EmptyView().anyView()
    }
}
