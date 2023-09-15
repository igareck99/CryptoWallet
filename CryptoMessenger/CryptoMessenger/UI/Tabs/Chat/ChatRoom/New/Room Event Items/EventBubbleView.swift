import SwiftUI

struct EventBubbleItem: Identifiable, ViewGeneratable {

    var id = UUID()
    let bubbleView: any View
    let reactions: any View
    let leadingContent: any ViewGeneratable
    let trailingContent: any ViewGeneratable

    // MARK: - Lifecycle
    
    init(bubbleView: any View,
         reactions: any View,
         leadingContent: any ViewGeneratable = ZeroViewModel(),
         trailingContent: any ViewGeneratable = ZeroViewModel()) {
        self.bubbleView = bubbleView
        self.reactions = reactions
        self.leadingContent = leadingContent
        self.trailingContent = trailingContent
    }

    func view() -> AnyView {
        EventBubbleView(leadingContent: leadingContent.view(),
                        bubbleContent: bubbleView.anyView(),
                        reactions: reactions.anyView(),
                        trailingContent: trailingContent.view())
            .anyView()
    }
}

// MARK: - EventBubbleView

struct EventBubbleView<LeadingContent: View,
                       BubbleContent: View,
                       Reactions: View,
                       TrailingContent: View>: View {
    let leadingContent: LeadingContent
    let bubbleContent: BubbleContent
    let reactions: Reactions
    let trailingContent: TrailingContent

    // MARK: - Body

    var body: some View {
        HStack(spacing: 8) {
            leadingContent
            VStack(alignment: .leading, spacing: 8) {
                bubbleContent
                reactions
            }
            trailingContent
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
    }
}
