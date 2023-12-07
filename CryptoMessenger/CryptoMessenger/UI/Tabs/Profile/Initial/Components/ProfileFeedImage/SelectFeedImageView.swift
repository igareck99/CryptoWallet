import SwiftUI

struct SelectFeedImageView<ViewModel: SelectFeedImageViewModelProtocol>: View {

    @StateObject var viewModel: ViewModel

    var body: some View {
        LazyVStack {
            ForEach(viewModel.displayItems, id: \.self) { type in
                HStack(alignment: .center, content: {
                    HStack(spacing: 16) {
                        type.image
                        Text(type.text)
                            .font(.calloutRegular16)
                    }
                    Spacer()
                })
                .padding(.horizontal, 16)
                .frame(height: 57)
                .onTapGesture {
                    viewModel.onSourceTypeTap(type: type.systemType)
                }
            }
        }
        .presentationDetents([.height(viewModel.itemsHeight())])
        .toolbar(.visible, for: .tabBar)
        .listStyle(.plain)
    }
}
