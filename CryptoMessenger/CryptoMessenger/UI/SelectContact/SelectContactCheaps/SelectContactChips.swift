import SwiftUI

// MARK: - SelectContactCheaps

struct SelectContactChips: ViewGeneratable {

    let id = UUID()
    let views: [any ViewGeneratable]
    @Binding var text: String
    
    func view() -> AnyView {
        return SelectContactChipsView(data: self).anyView()
    }
}
