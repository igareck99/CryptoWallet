import SwiftUI

struct TabItemModel: Identifiable, ViewGeneratable {
    let id = UUID()
    let title: String
    let icon: Image
    let tabType: MainTabs
    @ViewBuilder
    var viewContent: () -> AnyView

    init(
        title: String,
        icon: Image,
        tabType: MainTabs,
        @ViewBuilder
        viewContent: @escaping () -> AnyView
    ) {
        self.title = title
        self.icon = icon
        self.tabType = tabType
        self.viewContent = viewContent
    }

    @ViewBuilder
    func image(tab: MainTabs) -> AnyView {
        tabType == tab ?
        icon.update(color: .dodgerBlue)
            .anyView() :
        icon.update(color: .romanSilver)
            .anyView()
    }

    func view() -> AnyView {
        viewContent()
    }
}
