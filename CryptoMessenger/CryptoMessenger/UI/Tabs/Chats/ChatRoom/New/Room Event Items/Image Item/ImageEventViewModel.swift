import Combine
import SwiftUI

protocol ImageEventViewModelProtocol: ObservableObject {
    var state: DocumentImageState { get set }
    var thumbnailImage: Image { get set }
    var size: String { get set }
    var sizeOfFile: String { get set }
    var image: Image { get set }
    var model: ImageEvent { get }
    
    func getImage()
    func onImageTap()
}

// MARK: - ImageEventViewModel

final class ImageEventViewModel: ImageEventViewModelProtocol {

    @Published var state: DocumentImageState = .download
    @Published var thumbnailImage = Image("")
    @Published var image = Image("")
    @Published var size = ""
    @Published var sizeOfFile = ""
    let model: ImageEvent

    // MARK: - Private Properties

    private let remoteDataService: RemoteDataServiceProtocol
    private let fileService: FileManagerProtocol
    private var subscriptions = Set<AnyCancellable>()

    // MARK: - Lifecycle

    init(
        model: ImageEvent,
        remoteDataService: RemoteDataServiceProtocol = RemoteDataService.shared,
        fileService: FileManagerProtocol = FileManagerService.shared
    ) {
        self.model = model
        self.remoteDataService = remoteDataService
        self.fileService = fileService
        self.bindInput()
        self.initData()
    }

    // MARK: - Mark Methods

    func onImageTap() {
        model.onTap(image, model.imageUrl)
    }

    func getImage() {
        guard let url = model.imageUrl else { return }
        Task {
            // TODO: Для загрузки картинки должен использоваться сервис с возможностью кеширования
            // TODO: Для кеширования это не нужно сохранять картинку в файлы
            // TODO: переделать на целевой сервис
            let result = await remoteDataService.downloadWithBytes(url: url)
            guard let data = result?.0,
                  let savedUrl = self.fileService.saveFile(
                    name: self.getFileName(),
                    data: data,
                    pathExtension: "jpeg"
                  ) else {
                debugPrint("downloadDataRequest FAILED")
                await MainActor.run {
                    self.state = .download
                }
                return
            }
            await MainActor.run {
                guard let uiImage = UIImage(data: data) else {
                    self.state = .download
                    return
                }
                self.image = Image(uiImage: uiImage)
                self.size = savedUrl.fileSize()
                self.state = .hasBeenDownloadPhoto
            }
        }
    }

    // MARK: - Private methods

    private func getFileName() -> String {
        let name = model.imageUrl?.absoluteString.components(separatedBy: "/").last ?? ""
        return name
    }

    private func generatePreviewImage(url: URL) {
        AVAsset(url: url).generateThumbnail { [weak self] image in
            guard let self = self, let previewImage = image else { return }
            Task {
                await MainActor.run {
                    self.thumbnailImage = Image(uiImage: previewImage)
                }
            }
        }
    }

    private func convertToBytes(_ value: Int) -> String {
        return Units(bytes: Int64(value)).getReadableUnit()
    }

    private func initData() {
        guard let url = model.imageUrl else { return }
        self.state = .loading
        self.generatePreviewImage(url: url)
        self.sizeOfFile = self.convertToBytes(model.size)
        self.size = self.sizeOfFile
        let (isExist, path) = fileService.checkFileExist(
            name: getFileName(),
            pathExtension: "jpeg"
        )
        if isExist {
            DispatchQueue.main.async {
                guard let url = self.model.imageUrl else { return }
                guard let result = self.fileService.getImageFile(self.getFileName(), "jpeg") else { return }
                self.image = result
                self.state = .hasBeenDownloadPhoto
            }
        } else {
            self.getImage()
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
