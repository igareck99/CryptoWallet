import SwiftUI

// MARK: - SelectContactCheapsItem

struct SelectContactChipsItem: ViewGeneratable {

    var id = UUID()
    var mxId: String
    var name: String

    func getItemWidth() -> CGFloat {
        var size: CGFloat = name.width(font: FontDecor.regular(17).uiFont) + 16
        return size
    }

    func view() -> AnyView {
        return SelectContactChipsItemView(data: self)
            .anyView()
    }
}
