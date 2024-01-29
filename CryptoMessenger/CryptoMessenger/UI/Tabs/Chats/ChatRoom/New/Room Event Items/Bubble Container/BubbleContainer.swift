import SwiftUI

struct BubbleContainer: Identifiable, ViewGeneratable {
    let id = UUID()
    let fillColor: Color // bubbles
    let edges: Edge.Set
    let horizontalEdges: Edge.Set
    let offset: CGFloat
    let horizontalOffset: CGFloat
    let isFromCurrentUser: Bool
    let cornerRadius: CornersRadius
    let content: any ViewGeneratable
    let bottomContent: any ViewGeneratable
    var onSwipe: () -> Void
    var swipeEdge: Edge

    init(
        edges: Edge.Set = .vertical,
        offset: CGFloat = 8.0,
        horizontalEdges: Edge.Set = .horizontal,
        horizontalOffset: CGFloat = 8.0,
        isFromCurrentUser: Bool,
        fillColor: Color,
        cornerRadius: CornersRadius,
        content: any ViewGeneratable,
        bottomContent: any ViewGeneratable = ZeroViewModel(),
        onSwipe: @escaping () -> Void,
        swipeEdge: Edge
    ) {
        self.edges = edges
        self.offset = offset
        self.horizontalEdges = horizontalEdges
        self.horizontalOffset = horizontalOffset
        self.fillColor = fillColor
        self.isFromCurrentUser = isFromCurrentUser
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
