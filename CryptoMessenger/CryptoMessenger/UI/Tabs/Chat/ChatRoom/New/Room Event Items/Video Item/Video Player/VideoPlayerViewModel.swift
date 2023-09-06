import AVKit
import Foundation

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
        load(url: videoUrl)
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
}

private extension VideoPlayerViewModel {
    func load(url: URL) {
        Task {
            let result = await remoteDataService.downloadDataRequest(url: url)
            debugPrint("downloadDataRequest url: \(String(describing: result?.0))")
            debugPrint("downloadDataRequest request: \(String(describing: result?.1))")

            let fileName = "\(DateFormatter.underscoredDate()).mp4"
            guard let fileUrl = result?.0,
                  let savedUrl = self.saveFile(fileUrl: fileUrl, name: fileName) else {
                debugPrint("downloadDataRequest FAILED")
                return
            }
            debugPrint("downloadDataRequest savedUrl: \(savedUrl)")
            await MainActor.run {
                player = AVPlayer(url: savedUrl)
            }
        }
    }

    private func saveFile(fileUrl: URL, name: String) -> URL? {
        let fileManager = FileManager.default
        let documentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let filePath = documentDirectory.appendingPathComponent(name, isDirectory: false)
        debugPrint("downloadDataRequest savedUrl: \(filePath)")
        guard let data = try? Data(contentsOf: fileUrl) else { return nil }
        try? data.write(to: filePath, options: .noFileProtection)
        return filePath
    }
}

extension DateFormatter {
    static func underscoredDate() -> String {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YY_MMM_d_HH_mm_ss"
        let strDate = dateFormatter.string(from: date)
        return strDate
    }
}
