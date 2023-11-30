import SwiftUI

struct ProfileSettingsMenuView<ViewModel: ProfileSettingsMenuProtocol>: View {

    @StateObject var viewModel: ViewModel

    var body: some View {
        LazyVStack {
            ForEach(viewModel.settingsTypes(), id: \.self) { type in
                ProfileSettingsMenuRow(
                    title: type.result.title,
                    image: type.result.image,
                    notifications: 0
                )
                .background(.white)
                .frame(height: 57)
                .listRowSeparator(.hidden)
                .onTapGesture {
                    viewModel.onTapItem(type: type)
                }
                .padding(.horizontal, 16)
            }
        }
        .listStyle(.plain)
        .presentationDetents([.height(viewModel.viewHeight())])
    }
}
