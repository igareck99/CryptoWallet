import SwiftUI

// MARK: - ReactionsNewViewModel

struct ReactionsNewViewModel: ViewGeneratable {

    var id = UUID()
    var width: CGFloat
    var views: [any ViewGeneratable]
    var firstRow: [any ViewGeneratable] = []
    var secondRow: [any ViewGeneratable] = []
    var backgroundColor: Color
    
    // MARK: - Lifecycle

    init(width: CGFloat,
         views: [any ViewGeneratable],
         backgroundColor: Color) {
        self.width = width
        self.views = views
        self.backgroundColor = backgroundColor
        computeGrid(width)
    }

    private mutating func computeGrid(_ width: CGFloat) {
        let count = views.reduce(width, { x, y in
            let result = x - y.getItemWidth() - 4
            if result > 0 {
                firstRow.append(y)
            } else {
                secondRow.append(y)
            }
            return result
        })
    }

    func view() -> AnyView {
        return ReationsGridView(data: self).anyView()
    }
}
