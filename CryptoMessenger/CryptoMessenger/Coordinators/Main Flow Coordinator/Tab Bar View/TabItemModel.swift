import SwiftUI

struct TabItemModel: Identifiable, ViewGeneratable {
    let id = UUID()
    let title: String
    let icon: Image
    let tabType: MainTabs
    let tabView: AnyView

    init(
        title: String,
        icon: Image,
        tabType: MainTabs,
        tabView: AnyView
    ) {
        self.title = title
        self.icon = icon
        self.tabType = tabType
        self.tabView = tabView
    }

    @ViewBuilder
    func image(tab: MainTabs) -> AnyView {
        tabType == tab ?
        icon.update(color: .dodgerBlue)
            .anyView() :
        icon.update(color: .romanSilver)
            .anyView()
    }

    // MARK: - ViewGeneratable

    func view() -> AnyView {
        tabView
    }
}
