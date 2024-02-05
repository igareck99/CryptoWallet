import SwiftUI

// MARK: - BubbleContainerView

struct BubbleContainerView<
    BubbleContent: View,
    BottomContent: View
>: View {
    let model: BubbleContainer
    let content: BubbleContent
    let bottomContent: BottomContent
    var onSwipe: () -> Void

    var body: some View {
        VStack(spacing: .zero) {
            HStack(spacing: .zero) {
                content
                    .padding(model.edges, model.offset)
                    .padding(model.horizontalEdges, model.horizontalOffset)
            }
            .background(model.fillColor)
            .clipped()
            .shadow(color: Color.chineseShadow, radius: 0.0, x: 0.0, y: 1.5)
            .overlay(content: {
                let rectangle = UnevenRoundedRectangle(topLeadingRadius: 16,
                                                       bottomLeadingRadius: model.isFromCurrentUser == false ? 4 : 16,
                                                       bottomTrailingRadius:  model.isFromCurrentUser == true ? 4 : 16,
                                                       topTrailingRadius: 16, style: .continuous)
                rectangle
                    .background(.clear)
                    .foreground(.clear)
                    .overlay(rectangle.strokeBorder(model.isFromCurrentUser ? Color.water :
                                                        Color.bone, lineWidth: 0.5))
            })
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
        .addSwipeAction(
            menu: .swiped,
            edge: .trailing,
            isSwiped: .constant(false),
            action: {
                onSwipe()
            }, {
                Rectangle()
                    .frame(width: 70, alignment: .center)
                    .frame(maxHeight: .infinity)
                    .foregroundColor(.clear)
            })
        .fixedSize(horizontal: true, vertical: true)
    }
}
