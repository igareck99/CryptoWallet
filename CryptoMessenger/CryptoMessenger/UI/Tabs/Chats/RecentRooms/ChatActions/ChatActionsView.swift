import SwiftUI

// MARK: - ChatActionsView

struct ChatActionsView: View {

    // MARK: - Internal Properties

    let room: ChatActionsList
    let onSelect: GenericBlock<ChatActions>
    @State var sheetHeight: CGFloat = 177

    // MARK: - Body

    private var content: some View {
        VStack(alignment: .center, spacing: .zero) {
            ForEach(ChatActions.getAvailableActions(room.isWatchProfileAvailable,
                                                    room.isLeaveAvailable), id: \.self) { value in
                ChatActionsCellView(value: value, isPinned: room.isPinned)
                    .background(.white)
                    .frame(height: 52)
                    .onTapGesture {
                        onSelect(value)
                    }
                    .listRowSeparator(.hidden)
            }
        }
        .padding(.top, 10)
    }

    var body: some View {
        content
            .presentationDragIndicator(.visible)
            .presentationDetents([.height(sheetHeight)])
            .onAppear {
                let value = ChatActions.getSheetHeight(
                    room.isWatchProfileAvailable,
                    room.isLeaveAvailable
                )
                guard sheetHeight != value else { return }
                sheetHeight = value
            }
    }
}

struct ChatActionsCellView: View {
    
    let value: ChatActions
    let isPinned: Bool

    var body: some View {
        VStack(alignment: .center) {
            HStack(alignment: .center, spacing: 10) {
                value.image(isPinned)
                Text(value.text(isPinned))
                    .font(.calloutRegular16)
                    .foreground(value.color)
                Spacer()
            }
        }
        .padding(.horizontal, 16)
    }
}
