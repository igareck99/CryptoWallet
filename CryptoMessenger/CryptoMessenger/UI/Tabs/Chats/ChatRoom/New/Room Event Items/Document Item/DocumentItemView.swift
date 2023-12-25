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
        VStack(alignment: .leading) {
            HStack(spacing: 8) {
                DocumentImageStateView(state: $viewModel.state)
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
            HStack {
                reactions
                Spacer()
            }
            eventData
        }
        .frame(minWidth: 230, idealWidth: 230, maxWidth: 230)
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
