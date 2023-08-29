import SwiftUI

struct TransactionEvent: Identifiable, ViewGeneratable {
    let id = UUID()
    let title: String
    let subtitle: String
    let amount: String
    let amountBackColor: Color
    let reactionsGrid: any ViewGeneratable
    let eventData: any ViewGeneratable
    let onTap: () -> Void
    
    // MARK: - ViewGeneratable
    
    func view() -> AnyView {
        TransactionEventView(
            model: self,
            eventData: eventData.view(),
            reactions: reactionsGrid.view()
        ).anyView()
    }
}
