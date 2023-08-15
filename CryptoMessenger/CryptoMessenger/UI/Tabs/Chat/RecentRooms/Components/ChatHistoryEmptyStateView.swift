import SwiftUI

// MARK: - ChatHistoryEmptyState

struct ChatHistoryEmptyState<ViewModel>: View where ViewModel: ChatHistoryViewDelegate {

    // MARK: - Internal Properties

    @ObservedObject var viewModel: ViewModel
    @State private var isRotating = 0.0

    // MARK: - Body

    var body: some View {
        switch viewModel.viewState {
        case .noData:
            VStack(alignment: .center) {
                Spacer()
                VStack(spacing: 4) {
                    viewModel.sources.emptyState
                    Text(viewModel.sources.searchEmpty)
                        .font(.regular(22))
                    Text(viewModel.sources.enterData)
                        .multilineTextAlignment(.center)
                        .font(.regular(15))
                        .foreground(.darkGray())
                }
                Spacer()
            }.frame(width: 248)
        case .emptySearch:
            VStack(alignment: .center) {
                Spacer()
                VStack(spacing: 4) {
                    viewModel.sources.noDataImage
                    Text(viewModel.sources.noResult)
                        .font(.regular(22))
                    Text(viewModel.sources.nothingFind)
                        .multilineTextAlignment(.center)
                        .font(.regular(15))
                        .foreground(.darkGray())
                }
                Spacer()
            }.frame(width: 248)
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
