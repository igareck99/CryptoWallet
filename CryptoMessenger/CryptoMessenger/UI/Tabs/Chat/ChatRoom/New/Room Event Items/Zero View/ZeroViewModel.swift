import SwiftUI

struct ZeroViewModel: Identifiable, ViewGeneratable {

    let id = UUID()

    // MARK: - ViewGeneratable

    func view() -> AnyView {
        ZeroView(model: self).anyView()
    }
}
