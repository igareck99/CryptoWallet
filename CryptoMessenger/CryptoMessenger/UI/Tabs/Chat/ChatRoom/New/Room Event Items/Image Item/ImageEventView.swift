import SwiftUI

// MARK: - ImageEventView

struct ImageEventView<
    ViewModel: ImageEventViewModelProtocol,
    EventData: View,
    LoadData: View
>: View {
    let loadData: LoadData
    let eventData: EventData
    @StateObject var viewModel: ViewModel

    var body: some View {
        ZStack {
            ImageContentView(
                image: $viewModel.image,
                thumbnailImage: $viewModel.thumbnailImage,
                state: $viewModel.state
            )
            .onTapGesture {
                guard viewModel.state == .hasBeenDownloadPhoto else { return }
                viewModel.onImageTap()
            }
            .overlay {
                DocumentImageStateView(
                    state: $viewModel.state,
                    circleColor: .chineseBlack.opacity(0.4)
                )
                .onTapGesture {
                    switch viewModel.state {
                    case .download:
                        viewModel.getImage()
                    case .loading:
                        viewModel.state = .download
                    default:
                        break
                    }
                }
            }
            .overlay(alignment: .bottomTrailing) {
                eventData.padding([.trailing, .bottom], 8)
            }
            .overlay(alignment: .topLeading) {
                if viewModel.state == .loading || viewModel.state == .download {
                    DownloadImageView(data: $viewModel.size)
                        .padding([.top, .leading], 8)
                }
            }
        }
    }
}

struct DownloadImageView: View {

    @Binding var data: String

    var body: some View {
            HStack {
                Text(data)
                    .font(.regular(12))
                    .foregroundColor(.white)
                }
            .padding(.horizontal, 12)
            .background(Color.osloGrayApprox)
            .clipShape(
                RoundedRectangle(cornerRadius: 30)
            )
    }
}

struct ImageContentView: View {
    @Binding var image: Image
    @Binding var thumbnailImage: Image
    @Binding var state: DocumentImageState

    var body: some View {
        if state == .hasBeenDownloadPhoto {
            image
                .resizable()
                .scaledToFill()
                .frame(width: 245, height: 152)
                .cornerRadius(16)
        } else {
            thumbnailImage
                .frame(width: 245, height: 152)
                .cornerRadius(16)
        }
    }
}
