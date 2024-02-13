import SwiftUI

// MARK: - DocumentItemView

struct DocumentItemView<
    EventData: View,
    Reactions: View
>: View {

    // MARK: - Internal Properties

    let eventData: EventData
    let reactions: Reactions
    @StateObject var viewModel: DocumentItemViewModel

    // MARK: - Body

    var body: some View {
        VStack(alignment: .leading, spacing: .zero) {
            HStack(spacing: 8) {
                DocumentImageStateView(state: $viewModel.state, viewType: .file)
                VStack(alignment: .leading, spacing: 4) {
                    Text(viewModel.model.title)
                        .lineLimit(1)
                        .font(.bodyRegular17)
                        .foregroundColor(.chineseBlack)
                    Text(viewModel.size)
                        .font(.caption1Regular12)
                        .foregroundColor(.manatee)
                }
            }
            if !viewModel.model.hasReactions {
                eventData
            } else {
                VStack(spacing: .zero) {
                    HStack {
                        reactions
                        Spacer()
                    }
                    .padding(.top, 8)
                    eventData
                }
            }
        }
        .frame(minWidth: 214, idealWidth: 214, maxWidth: 214)
        .fixedSize(horizontal: true, vertical: false)
        .onTapGesture {
            withAnimation(.easeOut(duration: 0.15)) {
                switch viewModel.state {
                case .download:
                    viewModel.state = .loading
                    viewModel.dowloadData()
                case .loading:
                    viewModel.state = .download
                case .hasBeenDownloaded:
                    viewModel.model.onTap()
                case .hasBeenDownloadPhoto:
                    break
                }
            }
        }
    }
}
