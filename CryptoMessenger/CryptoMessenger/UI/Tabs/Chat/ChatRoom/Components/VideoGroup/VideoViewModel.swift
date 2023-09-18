import AVFoundation
import Combine
import CoreMedia
import SwiftUI

// MARK: - VideoViewModel

final class VideoViewModel: ObservableObject {

    // MARK: - Internal Properties
    
    @Published var videoUrl: URL?
    @Published var thumbnailUrl: URL?
    @Published var dataUrl: URL?
    @Published var isVideoUpload = false
    @Published var videoDuration = ""
    @Published var videoSize = ""
    @Published var videoState = false

    // MARK: - Private Properties

    private var subscriptions = Set<AnyCancellable>()
    private var dataService = RemoteDataService()
    private var fileService = FileManagerService()

    // MARK: - Lifecycle

    init(videoUrl: URL?,
         thumbnailUrl: URL?) {
        self.videoUrl = videoUrl
        self.thumbnailUrl = thumbnailUrl
        bindInput()
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
                    self.computeTime(url: url)
                    self.videoState = false
                    self.objectWillChange.send()
                case .notExist(_):
                    guard let videoUrl = self.videoUrl else { return }
                    self.dataService.downloadDataWithSize(withUrl: videoUrl,
                                                          httpMethod: .get)
                    self.videoState = true
                case .error:
                    return
                }
            }
        }
    }

    // MARK: - Private Properties

    private func bindInput() {
        dataService.dataSizePublisher
            .subscribe(on: DispatchQueue.global(qos: .userInitiated))
            .receive(on: DispatchQueue.main)
            .sink { [weak self] value in
                self?.videoSize = "\(value.saved) / \(value.expect)"
                self?.objectWillChange.send()
            }
            .store(in: &subscriptions)
        dataService.isFinishedLaunch
            .subscribe(on: DispatchQueue.global(qos: .userInitiated))
            .receive(on: DispatchQueue.main)
            .sink { [weak self] value in
                guard let url = value else { return }
                DispatchQueue.main.async {
                    self?.dataUrl = url
                    self?.computeTime(url: url)
                    self?.isVideoUpload = true
                }
            }
            .store(in: &subscriptions)
    }

    private func computeTime(url: URL) {
        let asset = AVAsset(url: url)
        let duration = asset.duration
        let durationTime = Int(CMTimeGetSeconds(duration))
        self.videoDuration = anotherIntToDate(durationTime)
    }
}
