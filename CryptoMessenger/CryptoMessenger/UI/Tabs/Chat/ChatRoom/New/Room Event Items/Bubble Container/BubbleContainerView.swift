import SwiftUI

struct BubbleContainerView<
    BubbleContent: View,
    BottomContent: View
>: View {
    let model: BubbleContainer
    let content: BubbleContent
    let bottomContent: BottomContent

    var body: some View {
        VStack(spacing: .zero) {
            HStack(spacing: .zero) {
                content.padding(model.edges, model.offset)
            }
            .background(model.fillColor)
            .cornerRadius(
                radius: model.cornerRadius.singleRadius,
                corners: model.cornerRadius.singleCorner
            )
            .cornerRadius(
                radius: model.cornerRadius.radius,
                corners: model.cornerRadius.corners
            )
            bottomContent
        }
        .fixedSize(horizontal: true, vertical: false)
    }
}
