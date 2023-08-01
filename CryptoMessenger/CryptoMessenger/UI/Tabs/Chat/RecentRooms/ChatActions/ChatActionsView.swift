import SwiftUI

// MARK: - ChatActionsView

struct ChatActionsView: View {

    // MARK: - Internal Properties

    let roomId: String
    let onSelect: GenericBlock<ChatActions>

    // MARK: - Body

    var body: some View {
        ForEach(ChatActions.allCases, id: \.self) { value in
            ProfileSettingsMenuRow(title: value.text, image: value.image,
                                   notifications: 0, color: value.color)
                .background(.white)
                .frame(height: 57)
                .onTapGesture {
                    onSelect(value)
                }
                .listRowSeparator(.hidden)
                .padding(.horizontal, 16)
        }
    }
}
