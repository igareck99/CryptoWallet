import SwiftUI
import Combine

// MARK: - VideoViewModel

final class VideoViewModel: ObservableObject {

    // MARK: - Internal Properties

    @Published var videoUrl: URL?
    @Published var thumbnailUrl: URL?
    @Published var dataUrl: URL?
    @Published var isVideoUpload = false
    private var dataService = RemoteDataService()
    private var fileService = FileManagerService()

    // MARK: - Lifecycle

    init(videoUrl: URL?,
         thumbnailUrl: URL?) {
        self.videoUrl = videoUrl
        self.thumbnailUrl = thumbnailUrl
        configVideo()
    }

    // MARK: - Private Methods

    private func configVideo() {
        if let url = videoUrl {
            fileService.checkBookFileExists(withLink: url.absoluteString,
                                            fileExtension: ".mp4") { state in
                switch state {
                case .exist(let url):
                    self.isVideoUpload = true
                    self.dataUrl = url
                case .notExist(let url):
                    guard let videoUrl = self.videoUrl else { return }
                    self.dataService.downloadData(withUrl: videoUrl,
                                                  httpMethod: .get) { data in
                        do {
                            guard let getData = data else { return }
                            try getData.write(to: url)
                            DispatchQueue.main.async {
                                self.dataUrl = url
                                self.isVideoUpload = true
                            }
                        } catch {
                        }
                    }
                case .error:
                    return
                }
            }
        }
    }
}
