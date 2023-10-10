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
            let result = await remoteDataService.downloadWithBytes(url: url)
            guard let data = result?.0,
                  let savedUrl = self.fileManager.saveFile(name: name,
                                                           data: data,
                                                           pathExtension: "mp4") else {
                debugPrint("downloadDataRequest FAILED")
                await MainActor.run {
                    self.state = .download
                }
                return
            }
            await MainActor.run {
                self.size = savedUrl.fileSize()
                self.downloadedUrl = savedUrl
                self.state = .hasBeenDownloadPhoto
            }
        }
    }
    
    func loadPreviewImage(url: URL) {
        url.getThumbnailImage { image in
            guard let previewImage = image else { return }
            Task {
                await MainActor.run {
                    self.thumbnailImage = previewImage
                }
            }
        }
    }

    // MARK: - Private Methods

    private func convertToBytes(_ value: Int) -> String {
        return Units(bytes: Int64(value)).getReadableUnit()
    }

    private func initData() {
        guard let vUrl = model.thumbnailurl else { return }
        self.loadPreviewImage(url: vUrl)
        let name = model.videoUrl?.absoluteString.components(separatedBy: "/").last ?? ""
        let (isExist, path) = fileManager.checkFileExist(name: name, pathExtension: "mp4")
        if isExist {
            DispatchQueue.main.async {
                guard let url = self.model.videoUrl else { return }
                self.downloadedUrl = path
                self.state = .hasBeenDownloadPhoto
            }
        } else {
            self.sizeOfFile = self.convertToBytes(model.size)
            self.size = self.sizeOfFile
        }
    }

    private func bindInput() {
        remoteDataService.dataSizePublisher
            .subscribe(on: DispatchQueue.global(qos: .default))
            .receive(on: DispatchQueue.global(qos: .default))
            .sink { [weak self] value in
                guard let self = self else { return }
                if self.state == .loading {
                    DispatchQueue.main.async {
                        self.size = "\(self.convertToBytes(value.savedBytes))/\(self.sizeOfFile)"
                    }
                }
            }
            .store(in: &subscriptions)
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
