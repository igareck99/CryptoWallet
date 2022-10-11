import SwiftUI
import AVKit

struct VideoFeedView: View {

    private let isFromCurrentUser: Bool
    private let shortDate: String
    private let videos = Video.fetchRemoteVideos()

    @State private var selectedVideo: Video?

    @State private var embeddedVideoRate: Float = 0.0
    @State private var embeddedVideoVolume: Float = 0.0
    @State private var shouldShowEmbeddedVideoInPiP = false

    init(
        isFromCurrentUser: Bool,
        shortDate: String
    ) {
        self.isFromCurrentUser = isFromCurrentUser
        self.shortDate = shortDate
    }

    var body: some View {
        Group {
            Button {
                selectedVideo = videos[0]
            } label: {
                ZStack(alignment: .center) {
                    ZStack {
                        VideoRow(video: videos[0])
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
        } content: { item in
            makeFullScreenVideoPlayer(for: item)
        }
    }

    @ViewBuilder
    private func makeFullScreenVideoPlayer(for video: Video) -> some View {
        if let url = video.videoURL {
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
