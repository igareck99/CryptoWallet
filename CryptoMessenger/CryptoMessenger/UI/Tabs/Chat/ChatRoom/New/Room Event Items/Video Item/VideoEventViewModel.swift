import AVKit
import Foundation
import SwiftUI

final class VideoEventViewModel: ObservableObject {

    @Published var thumbnailImage: Image?
    private var videoUrl: URL?
    private let fileManager: FileManagerProtocol
    private let remoteDataService: RemoteDataServiceProtocol

    init(
        fileManager: FileManagerProtocol = FileManagerService.shared,
        remoteDataService: RemoteDataServiceProtocol = RemoteDataService.shared
    ) {
        self.fileManager = fileManager
        self.remoteDataService = remoteDataService
    }

    func update(url: URL?) {
        debugPrint("url: \(String(describing: url))")
        guard videoUrl == nil else { return }
        guard let vUrl = url else { return }
        self.videoUrl = vUrl
        self.load(url: vUrl)
    }

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
            self.generatePreviewImage(url: savedUrl)
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

    func loadPreviewImage() {
        guard let vUrl = videoUrl else { return }
        videoUrl?.getThumbnailImage { image in
            guard let previewImage = image else { return }
            Task {
                await MainActor.run {
                    self.thumbnailImage = previewImage
                }
            }
        }
    }

    func generatePreviewImage(url: URL) {
        AVAsset(url: url).generateThumbnail { [weak self] image in
            guard let self = self, let previewImage = image else { return }
            Task {
                await MainActor.run {
                    self.thumbnailImage = Image(uiImage: previewImage)
                }
            }
        }
    }
}

extension AVAsset {

    func generateThumbnail(completion: @escaping (UIImage?) -> Void) {
        DispatchQueue.global().async {
            let imageGenerator = AVAssetImageGenerator(asset: self)
            let time = CMTime(seconds: 0.0, preferredTimescale: 600)
            let times = [NSValue(time: time)]
            imageGenerator.generateCGImagesAsynchronously(forTimes: times, completionHandler: { _, image, _, _, _ in
                if let image = image {
                    completion(UIImage(cgImage: image))
                } else {
                    completion(nil)
                }
            })
        }
    }
}
