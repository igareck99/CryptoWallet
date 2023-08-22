import SwiftUI

struct BubbleContainer: Identifiable, ViewGeneratable {
    let id = UUID()
    let fillColor: Color // bubbles
    let cornerRadius: CornersRadius
    let content: any ViewGeneratable
    let bottomContent: any ViewGeneratable
    
    init(
        fillColor: Color,
        cornerRadius: CornersRadius,
        content: any ViewGeneratable,
        bottomContent: any ViewGeneratable = ZeroViewModel()
    ) {
        self.fillColor = fillColor
        self.cornerRadius = cornerRadius
        self.content = content
        self.bottomContent = bottomContent
    }

    // MARK: - ViewGeneratable

    func view() -> AnyView {
        BubbleContainerView(
            model: self,
            content: content.view(),
            bottomContent: bottomContent.view()
        ).anyView()
    }
}
