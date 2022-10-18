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
                selectedVideo = Video(videoUrl: viewModel.videoUrl)
            } label: {
                ZStack(alignment: .center) {
                    ZStack {
                        VideoRow(viewModel: viewModel)
                            .scaledToFill()
                            .frame(width: 202, height: 245)
                        CheckReadView(time: shortDate,
                                      isFromCurrentUser: isFromCurrentUser)
                        .padding(.leading, isFromCurrentUser ? 0 : 130)
                    }
                    .scaledToFill()
                    .frame(width: 202, height: 245)
                    ZStack(alignment: .center) {
                        Circle()
                            .frame(width: 48, height: 48)
                            .foreground(.black(0.1))
                        Image(systemName: "play.fill")
                            .resizable()
                            .tint(.white)
                            .frame(width: 15, height: 15)
                    }
                }
            }
        }
        .frame(width: 202, height: 245)
        .fullScreenCover(item: $selectedVideo) {
            embeddedVideoRate = 1.0
        } content: { _ in
            makeFullScreenVideoPlayer()
        }
        .onAppear {
            viewModel.setupAudioNew { url in
                do {
                    guard let unwrappedUrl = url else { return }
                    self.videoUrl = unwrappedUrl
                } catch {
                    debugPrint("Error URL")
                    return
                }
            }
        }
    }

    // MARK: - ViewBuilder

    @ViewBuilder
    private func makeFullScreenVideoPlayer() -> some View {
        if let url = videoUrl {
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
