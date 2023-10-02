import SwiftUI

struct ReadData: Identifiable, ViewGeneratable {
    let id = UUID()
    let readImageName: Image

    // MARK: - ViewGeneratable

    func view() -> AnyView {
        ReadDataView(model: self).anyView()
    }
}
