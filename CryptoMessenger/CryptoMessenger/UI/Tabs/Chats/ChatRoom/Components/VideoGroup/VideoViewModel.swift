import AVFoundation
import Combine
import CoreMedia
import SwiftUI

// MARK: - VideoViewModel

final class VideoViewModel: ObservableObject {

    // MARK: - Internal Properties

    @Published var videoUrl: URL?
    @Published var thumbnailUrl: URL?
    @Published var thumbnailImage: Image?
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

    init(
        videoUrl: URL?,
        thumbnailUrl: URL?
    ) {
        self.videoUrl = videoUrl
        self.thumbnailUrl = thumbnailUrl
        bindInput()
        configVideo()
    }

    private func loadImageThumbnail() {
        Task {
            guard let image = await thumbnailUrl?.getThumbnailImage() else { return }
            await MainActor.run {
                self.thumbnailImage = image
            }
        }
    }

    // MARK: - Private Methods

    private func configVideo() {
        guard let url = videoUrl else { return }
        Task {
            let fileStatus = await fileService.checkBookFileExists(
                withLink: url.absoluteString,
                fileExtension: "mp4"
            )
            switch fileStatus {
                case .exist(let url):
                    isVideoUpload = true
                    await computeTime(url: url)
                    await MainActor.run {
                        dataUrl = url
                        videoState = false
                        objectWillChange.send()
                    }
                case .notExist(_):
                    guard let videoUrl = videoUrl else { return }
                    await dataService.downloadDataWithSize(
                        withUrl: videoUrl,
                        httpMethod: .get
                    )
                    await MainActor.run {
                        videoState = true
                    }
                case .error:
                    return
            }
        }
    }

    // MARK: - Private Properties

    private func bindInput() {
        dataService.dataSizePublisher
            .subscribe(on: DispatchQueue.global(qos: .userInitiated))
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
//                self?.videoSize = "\(value.saved) / \(value.expect)"
                self?.objectWillChange.send()
            }
            .store(in: &subscriptions)
        dataService.isFinishedLaunch
            .subscribe(on: DispatchQueue.global(qos: .userInitiated))
            .receive(on: DispatchQueue.main)
            .sink { [weak self] value in
                guard let self = self, let url = value else { return }
                Task {
                    await self.computeTime(url: url)
                    await MainActor.run {
                        self.dataUrl = url
                        self.isVideoUpload = true
                    }
                }
            }
            .store(in: &subscriptions)
    }

    private func computeTime(url: URL) async {
        guard let duration = try? await AVAsset(url: url).load(.duration) else {
            return
        }
        let durationTime = Int(CMTimeGetSeconds(duration))
        await MainActor.run {
            videoDuration = anotherIntToDate(durationTime)
        }
    }
}
