import AVKit
import Foundation

// MARK: - VideoPlayerViewModel

final class VideoPlayerViewModel: ObservableObject {
    private let videoUrl: URL
    private let fileManager: FileManagerProtocol
    private let remoteDataService: RemoteDataServiceProtocol
    private var asset: AVAsset
    private var playerItem: AVPlayerItem
    @Published var player: AVPlayer
    @Published var videoOpacity: Double = .zero

    init(
        videoUrl: URL,
        fileManager: FileManagerProtocol = FileManagerService.shared,
        remoteDataService: RemoteDataServiceProtocol = RemoteDataService.shared
    ) {
        self.videoUrl = videoUrl
        self.fileManager = fileManager
        self.remoteDataService = remoteDataService
        self.asset = AVAsset(url: videoUrl)
        self.playerItem = AVPlayerItem(asset: asset)
        self.player = AVPlayer(playerItem: playerItem)
        load()
    }

    func onDisappear() {
        player.pause()
        resetPlayer()
    }

    func onAppear() {
        Task {
            await playerItem.seek(to: CMTime.zero)
            await MainActor.run {
                player.play()
            }
        }
    }

    private func resetPlayer() {
        playerItem.seek(
            to: CMTime.zero,
            toleranceBefore: CMTime.zero,
            toleranceAfter: CMTime.zero,
            completionHandler: nil
        )
    }
    
    private func load() {
        Task {
            await MainActor.run {
                player = AVPlayer(url: videoUrl)
            }
        }
    }
}
