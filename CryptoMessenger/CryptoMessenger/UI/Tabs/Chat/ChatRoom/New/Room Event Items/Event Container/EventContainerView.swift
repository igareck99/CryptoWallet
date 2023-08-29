import SwiftUI

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

    var body: some View {
        VStack(spacing: 8) {
            HStack(spacing: 8) {
                leadingContent
                centralContent
                trailingContent
            }
            bottomContent
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
    }
}
