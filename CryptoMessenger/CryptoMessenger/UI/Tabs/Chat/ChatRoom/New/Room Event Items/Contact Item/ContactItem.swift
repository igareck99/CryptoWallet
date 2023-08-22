import SwiftUI

struct ContactItem: Identifiable, Equatable, Hashable, ViewGeneratable {
    let id = UUID()
    let title: String
    let subtitle: String
    let reactionsGrid: any ViewGeneratable
    let eventData: any ViewGeneratable
    let avatar: any ViewGeneratable
    let onTap: () -> Void
    
    // MARK: - ViewGeneratable
    
    func view() -> AnyView {
        ContactEventView(
            model: self,
            eventData: eventData.view(),
            reactions: reactionsGrid.view(),
            avatar: avatar.view()
        ).anyView()
    }
}
