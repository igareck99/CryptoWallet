import SwiftUI

struct ChatView<ViewModel: ChatViewModelProtocol>: View {
    @StateObject var viewModel: ViewModel
    var body: some View {
        List {
            ForEach(viewModel.displayItems, id: \.hashValue) { item in
                item.view()
                    .listRowSeparator(.hidden)
                    .listRowInsets(EdgeInsets())
            }
        }
        .listStyle(.plain)
    }
}
