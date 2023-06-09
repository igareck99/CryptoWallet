import SwiftUI

// MARK: - UserSettingsView

struct UserSettingsView<ViewModel: UserSettingsViewModelProtocol>: View {

    // MARK: - Internal Properties

    @StateObject var viewModel: ViewModel

    // MARK: - Body

    var body: some View {
        VStack(spacing: 0) {
            RoundedRectangle(cornerRadius: 3)
                .frame(width: 38, height: 6)
                .foregroundColor(.water)
                .padding(.top, 5)
                .padding(.bottom, 16)
            
            ForEach(viewModel.items, id: \.hashValue) { model in
                model.view()
                    .frame(height: 57)
            }
            Spacer()
        }
    }
}
