import SwiftUI

// MARK: - UserSettingsView

struct UserSettingsView<ViewModel: UserSettingsViewModelProtocol>: View {

    // MARK: - Internal Properties

    @StateObject var viewModel: ViewModel

    // MARK: - Body
    
    var body: some View {
        VStack(spacing: .zero) {
            ForEach(viewModel.items, id: \.hashValue) { model in
                model.view()
            }
        }
        .padding(.leading, 16)
    }
}
