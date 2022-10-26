import SwiftUI
import AVKit

// MARK: - VideoFeedView

struct VideoView: View {

    // MARK: - Internal Properties

    @StateObject var viewModel: VideoViewModel

    // MARK: - Private Properties

    @State private var selectedVideo: Video?
    @State private var embeddedVideoRate: Float = 0.0
    @State private var embeddedVideoVolume: Float = 0.0
    @State private var shouldShowEmbeddedVideoInPiP = false
    @State private var videoUrl: URL?
    @State private var videoState = FileStates.error
    private let isFromCurrentUser: Bool
    private let shortDate: String

    // MARK: - Private Properties

    init(
        isFromCurrentUser: Bool,
        shortDate: String,
        viewModel: VideoViewModel
    ) {
        self.isFromCurrentUser = isFromCurrentUser
        self.shortDate = shortDate
        self._viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        Group {
            Button {
                if viewModel.isVideoUpload {
                    selectedVideo = Video(videoUrl: viewModel.videoUrl)
                }
            } label: {
                ZStack(alignment: .center) {
                    ZStack {
                        VideoRow(viewModel: viewModel)
                            .scaledToFill()
                            .frame(width: 202, height: 245)
                        HStack {
                            makeVideoInfoView()
                                .padding(.bottom, 215)
                                .padding(.leading, 10)
                            CheckReadView(time: shortDate,
                                          isFromCurrentUser: isFromCurrentUser)
                            .padding(.leading, isFromCurrentUser ? 0 : 130)
                        }
                    }
                    .scaledToFill()
                    .frame(width: 202, height: 245)
                    makePlayView()
                }
            }
        }
        .frame(width: 202, height: 245)
        .fullScreenCover(item: $selectedVideo) {
            embeddedVideoRate = 1.0
        } content: { _ in
            makeFullScreenVideoPlayer()
        }
        .onChange(of: viewModel.dataUrl) { value in
            if value != nil {
                viewModel.isVideoUpload = true
                videoUrl = value
            }
        }
    }

    // MARK: - ViewBuilder

    @ViewBuilder
    private func makeVideoInfoView() -> some View {
        ZStack {
            if viewModel.isVideoUpload {
                Text("\(viewModel.videoDuration)")
                    .foreground(.white())
                    .font(.regular(12))
                RoundedRectangle(cornerRadius: 13, style: .continuous)
                    .fill(Color(.black(0.4)))
                    .frame(width: 32, height: 14)
            } else {
                Text("\(viewModel.videoSize)")
                    .foreground(.white())
                    .font(.regular(12))
                    .lineLimit(1)
                RoundedRectangle(cornerRadius: 13, style: .continuous)
                    .fill(Color(.black(0.4)))
                    .frame(width: 102, height: 16)
            }
        }
    }

    @ViewBuilder
    private func makePlayView() -> some View {
        ZStack(alignment: .center) {
            if viewModel.isVideoUpload {
                Circle()
                    .frame(width: 48, height: 48)
                    .foreground(.black(0.1))
                Image(systemName: "play.fill")
                    .resizable()
                    .tint(.white)
                    .frame(width: 15, height: 15)
            } else {
                ProgressView()
                    .frame(width: 48, height: 48)
            }
        }
    }

    @ViewBuilder
    private func makeFullScreenVideoPlayer() -> some View {
        if let url = viewModel.dataUrl {
            let avPlayer = AVPlayer(url: url)
            VideoPlayerView(player: avPlayer)
                .edgesIgnoringSafeArea(.all)
                .onAppear {
                    embeddedVideoRate = 0.0
                }
        } else {
            ErrorView()
        }
    }
}
