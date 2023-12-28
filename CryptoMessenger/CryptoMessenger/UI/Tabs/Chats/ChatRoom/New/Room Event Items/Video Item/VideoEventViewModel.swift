import AVKit
import Combine
import SwiftUI

// MARK: - VideoEventViewModel

final class VideoEventViewModel: ObservableObject {

    // MARK: - Internal Properties

    @Published var thumbnailImage = Image("")
    @Published var image = Image("")
    @Published var size = ""
    @Published var sizeOfFile = ""
    @Published var state: DocumentImageState = .download
    var downloadedUrl: URL?
    var model: VideoEvent

    // MARK: - Private Properties

    private let fileManager: FileManagerProtocol
    private let remoteDataService: RemoteDataServiceProtocol
    private var subscriptions = Set<AnyCancellable>()

    // MARK: - Lifecycle

    init(
        model: VideoEvent,
        fileManager: FileManagerProtocol = FileManagerService.shared,
        remoteDataService: RemoteDataServiceProtocol = RemoteDataService.shared
    ) {
        self.model = model
        self.fileManager = fileManager
        self.remoteDataService = remoteDataService
        self.bindInput()
        self.initData()
    }
    
    func onTapView() {
        switch state {
        case .download:
            state = .loading
            getData()
        case .loading:
            state = .download
        case .hasBeenDownloadPhoto:
            guard let url = downloadedUrl else { return }
            model.onTap(url)
        default:
            break
        }
    }

    func getData() {
        guard let url = model.videoUrl else { return }
        let name = model.videoUrl?.absoluteString.components(separatedBy: "/").last ?? ""
        Task {
            guard let data = await remoteDataService.downloadWithBytes(url: url)?.0,
                  let savedUrl = await self.fileManager.saveFile(
                    name: name,
                    data: data,
                    pathExtension: "mp4"
                  ) else {
                debugPrint("downloadDataRequest FAILED")
                await MainActor.run {
                    self.state = .download
                }
                return
            }
            let fileSize = await savedUrl.fileSize()
            await MainActor.run {
                self.size = fileSize
                self.downloadedUrl = savedUrl
                self.state = .hasBeenDownloadPhoto
            }
        }
    }

    func loadPreviewImage(url: URL) {
        Task {
            guard let image = await url.getThumbnailImage() else { return }
            await MainActor.run {
                self.thumbnailImage = image
            }
        }
    }

    // MARK: - Private Methods

    private func convertToBytes(_ value: Int) -> String {
        return Units(bytes: Int64(value)).getReadableUnit()
    }

    private func initData() {
        guard let vUrl = model.thumbnailurl else { return }
        Task {
            loadPreviewImage(url: vUrl)
            let fileName = model.videoUrl?.absoluteString.components(separatedBy: "/").last ?? ""
            let (isExist, path) = await fileManager.checkFileExist(
                name: fileName,
                pathExtension: "mp4"
            )
            guard isExist else {
                self.sizeOfFile = self.convertToBytes(model.size)
                self.size = self.sizeOfFile
                return
            }

            guard self.model.videoUrl != nil else { return }

            await MainActor.run {
                self.downloadedUrl = path
                self.state = .hasBeenDownloadPhoto
            }
        }
    }

    private func bindInput() {
        remoteDataService.dataSizePublisher
            .subscribe(on: DispatchQueue.global(qos: .default))
            .receive(on: DispatchQueue.global(qos: .default))
            .sink { [weak self] value in
                guard let self = self, self.state == .loading else { return }
                let bytes = self.convertToBytes(value.savedBytes)
                Task {
                    await MainActor.run {
                        self.size = "\(bytes)/\(self.sizeOfFile)"
                    }
                }
            }
            .store(in: &subscriptions)
    }
}
