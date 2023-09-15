import SwiftUI

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

    var body: some View {
        HStack(spacing: 8) {
            leadingContent
            VStack(alignment: .leading, spacing: 8) {
                centralContent
                bottomContent
            }
            trailingContent
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
    }
}
