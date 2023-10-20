import SwiftUI

struct SheetDragItem: ViewGeneratable {
    let id = UUID()
    let itemColor: Color

    init(
        itemColor: Color = .chineseBlack04
    ) {
        self.itemColor = itemColor
    }

    // MARK: - ViewGeneratable

    func view() -> AnyView {
        SheetDragItemView(model: self).anyView()
    }
}
