import SwiftUI

struct AudioEvent: Identifiable, ViewGeneratable {
    let id = UUID()
    
    // MARK: - ViewGeneratable
    
    func view() -> AnyView {
        EmptyView().anyView()
    }
}
