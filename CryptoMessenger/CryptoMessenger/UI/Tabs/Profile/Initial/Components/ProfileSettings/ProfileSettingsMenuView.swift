import SwiftUI

struct ProfileSettingsMenuView<ViewModel: ProfileSettingsMenuProtocol>: View {

    @StateObject var viewModel: ViewModel

    var body: some View {
        VStack(spacing: .zero) {
            ForEach(viewModel.settingsTypes(), id: \.self) { type in
                ProfileSettingsMenuRow(
                    title: type.result.title,
                    image: type.result.image,
                    notifications: 0
                )
                .background(.white)
                .frame(height: 52)
                .listRowSeparator(.hidden)
                .onTapGesture {
                    viewModel.onTapItem(type: type)
                }
                .padding(.horizontal, 16)
            }
        }
        .padding(.top, 6)
        .listStyle(.plain)
        .presentationDetents([.height(viewModel.viewHeight())])
        .presentationDragIndicator(.visible)
    }
}
