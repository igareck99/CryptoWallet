import SwiftUI

struct TabItemsView<ViewModel: TabItemsViewModelProtocol>: View {

    @State private var selectedItem = MainTabs.chat
    @StateObject var viewModel: ViewModel

    var body: some View {
        TabView(selection: $selectedItem) {
            ForEach(viewModel.tabs, id: \.id) { tab in
                tab.view().tabItem {
                    Label {
                        Text(tab.title)
                    } icon: {
                        tab.image(tab: selectedItem)
                    }
                }.tag(tab.tabType)
            }
        }
        .toolbar(.visible, for: .navigationBar)
    }
}
