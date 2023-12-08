import SwiftUI

struct SystemEvent: Identifiable, ViewGeneratable {
    let id = UUID()
    let text: String
    let textColor: Color
    let backColor: Color
    let onTap: () -> Void

    // MARK: - ViewGeneratable

    func view() -> AnyView {
        SystemEventView(model: self).anyView()
    }
}
