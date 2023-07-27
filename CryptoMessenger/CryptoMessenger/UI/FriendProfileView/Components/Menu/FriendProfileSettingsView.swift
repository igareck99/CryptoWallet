import SwiftUI

// MARK: - FriendProfileSettingsView

struct FriendProfileSettingsView: View {

    // MARK: - Internal Properties

    @StateObject var viewModel: FriendProfileViewModel
    let onSelect: GenericBlock<FriendProfileSettingsMenu>

    // MARK: - Body

    var body: some View {
        VStack(spacing: 0) {
            RoundedRectangle(cornerRadius: 2)
                .frame(width: 31, height: 4)
                .foreground(.darkGray(0.4))
                .padding(.top, 6)

            List {
                ForEach(FriendProfileSettingsMenu.allCases, id: \.self) { type in
                    FriendProfileMenuRow(item: type)
                            .background(.white())
                            .listRowSeparator(.hidden)
                            .onTapGesture { onSelect(type) }
                }
            }
            .listStyle(.plain)
        }
    }
}
