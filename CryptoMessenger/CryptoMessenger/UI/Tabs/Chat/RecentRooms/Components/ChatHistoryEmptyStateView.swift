import SwiftUI

// MARK: - ChatHistoryEmptyState

struct ChatHistoryEmptyState: View {

    // MARK: - Internal Properties
    @Binding var viewState: ChatHistoryViewState
    @State private var isRotating = 0.0

    // MARK: - Body

    var body: some View {
        switch viewState {
        case .noData:
            EmptyInfoViewModel(value: ChatHistoryEmpty.noData).view()
                .frame(width: 248)
        case .emptySearch:
            EmptyInfoViewModel(value: ChatHistoryEmpty.emptySearch).view()
                .frame(width: 248)
        case .loading:
            loadingStateView()
        default:
            EmptyView()
        }
    }

    @ViewBuilder
    private func loadingStateView() -> some View {
        VStack {
            Spacer()
            R.image.wallet.loader.image
                .rotationEffect(.degrees(isRotating))
                .onAppear {
                    withAnimation(
                        .linear(duration: 1)
                        .speed(0.4)
                        .repeatForever(autoreverses: false)
                    ) {
                        isRotating = 360.0
                    }
                }
                .onDisappear {
                    isRotating = 0
                }
            Spacer()
        }
    }
}
