import SwiftUI

struct LoadInfo: Identifiable, ViewGeneratable {
    let id = UUID()
    let url: URL
    let textColor: Color
    let backColor: Color

    // MARK: - ViewGenerateble

    func view() -> AnyView {
        LoadInfoView(model: self).anyView()
    }
}
