import SwiftUI

// swiftlint:disable void_return

struct EventContainer: Identifiable, ViewGeneratable {
    let id: UUID
    let leadingContent: any ViewGeneratable
    let centralContent: any ViewGeneratable
    let trailingContent: any ViewGeneratable
    let bottomContent: any ViewGeneratable
    var onLongPress: () -> Void

    init(
        id: UUID = UUID(),
        leadingContent: any ViewGeneratable = ZeroViewModel(),
        centralContent: any ViewGeneratable = ZeroViewModel(),
        trailingContent: any ViewGeneratable = ZeroViewModel(),
        bottomContent: any ViewGeneratable = ZeroViewModel(),
        onLongPress: @escaping () -> Void
    ) {
        self.id = id
        self.leadingContent = leadingContent
        self.centralContent = centralContent
        self.trailingContent = trailingContent
        self.bottomContent = bottomContent
        self.onLongPress = onLongPress
    }

    // MARK: - ViewGeneratable

    func view() -> AnyView {
        EventContainerView(
            leadingContent: leadingContent.view(),
            centralContent: centralContent.view(),
            trailingContent: trailingContent.view(),
            bottomContent: bottomContent.view(),
            onLongPress: onLongPress
        ).anyView()
    }
}
