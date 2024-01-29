import SwiftUI

// swiftlint:disable void_return

struct EventContainer: Identifiable, ViewGeneratable {
    let id: UUID
    let leadingContent: any ViewGeneratable
    let centralContent: any ViewGeneratable
    let trailingContent: any ViewGeneratable
    let bottomContent: any ViewGeneratable
    let reactionsSpacing: CGFloat
    let nextMessagePadding: CGFloat
    var onLongPress: () -> Void
    var onTap: () -> Void

    init(
        id: UUID = UUID(),
        leadingContent: any ViewGeneratable = ZeroViewModel(),
        centralContent: any ViewGeneratable = ZeroViewModel(),
        trailingContent: any ViewGeneratable = ZeroViewModel(),
        bottomContent: any ViewGeneratable = ZeroViewModel(),
        reactionsSpacing: CGFloat = 0.0,
        nextMessagePadding: CGFloat,
        onLongPress: @escaping () -> Void,
        onTap: @escaping () -> Void
    ) {
        self.id = id
        self.leadingContent = leadingContent
        self.centralContent = centralContent
        self.trailingContent = trailingContent
        self.bottomContent = bottomContent
        self.reactionsSpacing = reactionsSpacing
        self.onLongPress = onLongPress
        self.onTap = onTap
        self.nextMessagePadding = nextMessagePadding
    }

    // MARK: - ViewGeneratable

    func view() -> AnyView {
        EventContainerView(
            leadingContent: leadingContent.view(),
            centralContent: centralContent.view(),
            trailingContent: trailingContent.view(),
            bottomContent: bottomContent.view(),
            reactionsSpacing: reactionsSpacing,
            nextMessagePadding: nextMessagePadding,
            onLongPress: onLongPress,
            onTap: onTap
        ).anyView()
    }
}
