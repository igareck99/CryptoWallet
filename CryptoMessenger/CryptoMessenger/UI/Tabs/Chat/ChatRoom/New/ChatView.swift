import SwiftUI

struct ChatView<ViewModel>: View where ViewModel: ChatViewModelProtocol {
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
        .onAppear {
            viewModel.eventSubject.send(.onAppear)
        }
        .toolbar(.hidden, for: .tabBar)
        .toolbar(.visible, for: .navigationBar)
    }
}
