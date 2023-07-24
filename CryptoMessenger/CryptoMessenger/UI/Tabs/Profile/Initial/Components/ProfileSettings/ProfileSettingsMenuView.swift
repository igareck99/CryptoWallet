import SwiftUI

// MARK: - ProfileSettingsMenuView

struct ProfileSettingsMenuView: View {
    
    // MARK: - Internal Properties
    
    @StateObject var viewModel: ProfileSettingsMenuViewModel
    let onSelect: GenericBlock<ProfileSettingsMenu>
    
    // MARK: - Body
    
    var body: some View {
        LazyVStack {
            ForEach(viewModel.settingsTypes(), id: \.self) { type in
                ProfileSettingsMenuRow(title: type.result.title, image: type.result.image, notifications: 0)
                    .background(.white)
                    .frame(height: 57)
                    .listRowSeparator(.hidden)
                    .onTapGesture { onSelect(type) }
                    .padding(.horizontal, 16)
            }
        }
        .listStyle(.plain)
    }
}
