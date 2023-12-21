import SwiftUI

// MARK: - QuickMenuView

struct QuickMenuView: View {

    // MARK: - Internal Properties

    @StateObject var viewModel: QuickMenuViewModel

    // MARK: - Private Properties

    @State private var isShown = false

    // MARK: - Body

    var body: some View {
        content
            .presentationDragIndicator(.visible)
            .presentationDetents(
                [.height(viewModel.height)]
            )
    }

    private var content: some View {
        VStack(spacing: 0) {
            ReactionsSelectView(onReaction: viewModel.onReaction)
            .padding(.horizontal, 16)
            Divider()
                .foreground(.lightGray)
            generateItems()
        }
    }

    private func generateItems() -> some View {
        return ForEach(viewModel.items, id: \.id) { item in
            HStack {
                item.action.image
                Text(item.action.title)
                    .font(.calloutRegular16)
                    .foregroundColor(item.action == .delete ? .spanishCrimson : .chineseBlack)
                Spacer()
            }
            .frame(height: 52)
            .padding(.horizontal, 16)
            .onTapGesture {
                vibrate()
                viewModel.onAction(item.action)
            }
        }
    }
}
