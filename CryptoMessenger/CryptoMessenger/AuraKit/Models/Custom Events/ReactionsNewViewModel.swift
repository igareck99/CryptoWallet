import SwiftUI

// MARK: - ReactionsNewViewModel

struct ReactionsNewViewModel: ViewGeneratable {
    
    var id = UUID()
    var width: CGFloat
    var views: [any ViewGeneratable]
    
    func computeGrid(_ width: CGFloat) -> [GridItem] {
        var viewWidth: CGFloat = 0
        var items: [GridItem] = [GridItem(.adaptive(minimum: 43, maximum: 60))]
        views.map {
            viewWidth -= $0.getItemWidth()
            if viewWidth < width {
                items.append(GridItem(.adaptive(minimum: 43, maximum: 60)))
            }
        }
        
        return items
    }
    
    func view() -> AnyView {
        return ReationsGridView(columns: computeGrid(width),
                                items: views).anyView()
    }
}
