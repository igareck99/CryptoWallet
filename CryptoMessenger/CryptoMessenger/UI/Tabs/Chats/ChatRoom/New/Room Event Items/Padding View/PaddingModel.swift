import SwiftUI

struct PaddingModel: Identifiable, ViewGeneratable {
    let id = UUID()

    // MARK: - ViewGeneratable

    func view() -> AnyView {
        PaddingView().anyView()
    }
}
