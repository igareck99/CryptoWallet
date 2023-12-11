import SwiftUI

struct BubbleContainer: Identifiable, ViewGeneratable {
    let id = UUID()
    let fillColor: Color // bubbles
    let edges: Edge.Set
    let offset: CGFloat
    let cornerRadius: CornersRadius
    let content: any ViewGeneratable
    let bottomContent: any ViewGeneratable
    var onSwipe: () -> Void
    var swipeEdge: Edge

    init(
        edges: Edge.Set = .all,
        offset: CGFloat = 8.0,
        fillColor: Color,
        cornerRadius: CornersRadius,
        content: any ViewGeneratable,
        bottomContent: any ViewGeneratable = ZeroViewModel(),
        onSwipe: @escaping () -> Void,
        swipeEdge: Edge
    ) {
        self.edges = edges
        self.offset = offset
        self.fillColor = fillColor
        self.cornerRadius = cornerRadius
        self.content = content
        self.bottomContent = bottomContent
        self.onSwipe = onSwipe
        self.swipeEdge = swipeEdge
    }

    // MARK: - ViewGeneratable

    func view() -> AnyView {
        BubbleContainerView(
            model: self,
            content: content.view(),
            bottomContent: bottomContent.view(),
            onSwipe: onSwipe
        ).anyView()
    }
}