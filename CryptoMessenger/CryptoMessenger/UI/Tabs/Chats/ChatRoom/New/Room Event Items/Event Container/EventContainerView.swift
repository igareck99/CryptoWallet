import SwiftUI

// swiftlint:disable void_return

// MARK: - EventContainerView

struct EventContainerView<
    LeadingContent: View,
    CentralContent: View,
    TrailingContent: View,
    BottomContent: View
>: View {

    let leadingContent: LeadingContent
    let centralContent: CentralContent
    let trailingContent: TrailingContent
    let bottomContent: BottomContent
    let reactionsSpacing: CGFloat
    let  nextMessagePadding: CGFloat
    var onLongPress: () -> Void
    var onTap: () -> Void

    var body: some View {
        VStack {
            HStack(spacing: 8) {
                leadingContent
                VStack(alignment: .leading, spacing: reactionsSpacing) {
                    centralContent
                    bottomContent
                }
                .onLongPressGesture {
                    onLongPress()
                }
                .onTapGesture(perform: onTap)
                trailingContent
            }
            .padding(.horizontal, 16)
            Rectangle()
                .frame(width: 1,
                       height: nextMessagePadding)
                .foreground(.clear)
        }
        .padding(.horizontal, 16)
//        .padding(.vertical, 4)
    }
}
