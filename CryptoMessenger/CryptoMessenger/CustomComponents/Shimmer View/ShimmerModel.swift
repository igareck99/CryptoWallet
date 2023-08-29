import SwiftUI

struct ShimmerModel: Identifiable, ViewGeneratable {

    static let dShimmer = ShimmerModel(shimmColor: .chineseBlackLoad)

    let id = UUID()
    let shimmColor: Color

    init(shimmColor: Color = .chineseBlackLoad) {
        self.shimmColor = shimmColor
    }

    // MARK: - ViewGeneratable

    func view() -> AnyView {
        ShimmerView().anyView()
    }
}
