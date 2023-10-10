import SwiftUI

struct VideoEventView<
    Placeholder: View,
    EventData: View,
    LoadData: View
>: View {

    @StateObject var viewModel: VideoEventViewModel

    let loadData: LoadData
    let placeholder: Placeholder
    let eventData: EventData
    
    var body: some View {
        ZStack {
            VideoContentView(image: $viewModel.thumbnailImage,
                             thumbnailImage: $viewModel.thumbnailImage,
                             state: $viewModel.state)
                .overlay {
                    DocumentImageStateView(state: $viewModel.state,
                                           circleColor: .chineseBlack.opacity(0.4))
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
                .onTapGesture {
                    viewModel.onTapView()
                }
        }
        .frame(width: 208, height: 250)
    }
}

struct VideoContentView: View {
    @Binding var image: Image
    @Binding var thumbnailImage: Image
    @Binding var state: DocumentImageState
    
    var body: some View {
        if state == .hasBeenDownloadPhoto {
            image
                .resizable()
                .frame(width: 208, height: 250)
                .cornerRadius(16)
        } else {
            thumbnailImage
                .frame(width: 208, height: 250)
                .cornerRadius(16)
        }
    }
}
