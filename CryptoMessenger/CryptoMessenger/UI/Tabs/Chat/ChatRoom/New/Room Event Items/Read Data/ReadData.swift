import SwiftUI

struct ReadData: Identifiable, ViewGeneratable {
    let id = UUID()
    let readImageName: String

    // MARK: - ViewGeneratable

    func view() -> AnyView {
        ReadDataView(model: self).anyView()
    }
}
