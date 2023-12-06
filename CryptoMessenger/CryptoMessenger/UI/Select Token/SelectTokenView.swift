import SwiftUI

struct SelectTokenView<ViewModel: SelectTokenViewModelProtocol>: View {

    @StateObject var viewModel: ViewModel

    var body: some View {
        VStack(spacing: 16) {
            RoundedRectangle(cornerRadius: 2)
                .frame(width: 31, height: 4)
                .foreground(.romanSilver07)
                .padding(.top, 6)
            ForEach(viewModel.displayItems, id: \.hashValue) { item in
                item.view()
            }
        }
        .background(viewModel.resources.background)
        .presentationDetents([.height(viewModel.height)])
    }
}
