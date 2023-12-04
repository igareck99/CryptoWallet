import SwiftUI

struct PinchToZoom: ViewModifier {
    @State var scale: CGFloat = 1.0
    @State var anchor: UnitPoint = .center
    @State var offset: CGSize = .zero
    @State var isPinching: Bool = false

    func body(content: Content) -> some View {
        content
            .scaleEffect(scale, anchor: anchor)
            .offset(offset)
            .overlay(
                PinchZoom(
                    scale: $scale,
                    anchor: $anchor,
                    offset: $offset,
                    isPinching: $isPinching
                )
            )
    }
}
