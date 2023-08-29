import SwiftUI

struct EventContainer: Identifiable, ViewGeneratable {
    let id = UUID()
    let leadingContent: any ViewGeneratable
    let centralContent: any ViewGeneratable
    let trailingContent: any ViewGeneratable
    let bottomContent: any ViewGeneratable

    init(
        leadingContent: any ViewGeneratable = ZeroViewModel(),
        centralContent: any ViewGeneratable = ZeroViewModel(),
        trailingContent: any ViewGeneratable = ZeroViewModel(),
        bottomContent: any ViewGeneratable = ZeroViewModel()
    ) {
        self.leadingContent = leadingContent
        self.centralContent = centralContent
        self.trailingContent = trailingContent
        self.bottomContent = bottomContent
    }

    // MARK: - ViewGeneratable

    func view() -> AnyView {
        EventContainerView(
            leadingContent: leadingContent.view(),
            centralContent: centralContent.view(),
            trailingContent: trailingContent.view(),
            bottomContent: bottomContent.view()
        ).anyView()
    }
}
