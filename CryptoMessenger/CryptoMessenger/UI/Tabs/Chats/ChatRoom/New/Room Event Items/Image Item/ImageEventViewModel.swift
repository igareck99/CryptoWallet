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
    
    func getImageOnAppear() {
        if !model.eventId.isEmpty {
            Task {
                let (isExist, path) = await fileService.checkFileExist(
                    name: getFileName(),
                    pathExtension: "jpeg"
                )
                print("saslaslkas  \(path)")
            }
        }
    }

    func getImage() {
        guard let url = model.imageUrl else { return }
        Task {
            // TODO: Для загрузки картинки должен использоваться сервис с возможностью кеширования
            // TODO: Для кеширования это не нужно сохранять картинку в файлы
            // TODO: переделать на целевой сервис
            guard let data = await remoteDataService.downloadWithBytes(url: url)?.0,
                  let savedUrl = await fileService.saveFile(
                    name: getFileName(),
                    data: data,
                    pathExtension: "jpeg"
                  ) else {
                debugPrint("downloadDataRequest FAILED")
                await MainActor.run {
                    // MARK: Загрузить не удалось, а state download ???
                    state = .download
                }
                return
            }

            guard let uiImage = UIImage(data: data) else {
                await MainActor.run {
                    state = .download
                }
                return
            }

            let fileSize = await savedUrl.fileSize()
            let img = Image(uiImage: uiImage)
            await MainActor.run {
                self.image = img
                self.size = fileSize
                self.state = .hasBeenDownloadPhoto
            }
        }
    }

    // MARK: - Private methods

    private func getFileName() -> String {
        let name = model.eventId.components(separatedBy: "/").last ?? ""
        return name
    }

    private func generatePreviewImage(url: URL) async {
        guard let image = await url.generateThumbnail() else { return }
        let img = Image(uiImage: image)
        await MainActor.run {
            thumbnailImage = img
        }
    }

    private func convertToBytes(_ value: Int) -> String {
        return Units(bytes: Int64(value)).getReadableUnit()
    }

    private func initData() {
        guard let url = model.imageUrl else { return }

        Task {
            await MainActor.run {
                state = .loading
            }
            await self.generatePreviewImage(url: url)

            self.sizeOfFile = self.convertToBytes(model.size)
            self.size = self.sizeOfFile

            let (isExist, _) = await fileService.checkFileExist(
                name: getFileName(),
                pathExtension: "jpeg"
            )

            guard isExist  else { self.getImage(); return }
            guard let url = self.model.imageUrl else { return } // MARK: Эта проверка нужна  ???????
            let fielName = self.getFileName()
            guard let result = await self.fileService.getImageFile(
                path: fielName,
                pathExtension: "jpeg"
            ) else {
                return
            }

            await MainActor.run {
                self.image = result
                self.state = .hasBeenDownloadPhoto
            }
        }
    }

    private func bindInput() {
        remoteDataService.dataSizePublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] value in
                guard let self = self else { return }
                Task {
                    let bytes = self.convertToBytes(value.savedBytes)
                    await MainActor.run {
                        guard self.state == .loading else { return }
                        self.size = "\(bytes)/\(self.sizeOfFile)"
                    }
                }
            }
            .store(in: &subscriptions)
    }
}
