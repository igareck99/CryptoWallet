import Combine

// MARK: - DocumentItemViewModel

final class DocumentItemViewModel: ObservableObject {

    let model: DocumentItem
    @Published var state: DocumentImageState
    @Published var size = ""
    @Published var sizeOfFile = ""
    @Published var dataUrl: URL?
    @Published var savedData = SavedExpectData(savedBytes: 1)
    let remoteDataService: RemoteDataServiceProtocol
    let fileService: FileManagerProtocol

    // MARK: - Private Methods

    private var subscriptions = Set<AnyCancellable>()

    // MARK: - Lifecycle

    init(
        model: DocumentItem,
        remoteDataService: RemoteDataServiceProtocol = RemoteDataService.shared,
        fileService: FileManagerProtocol = FileManagerService.shared
    ) {
        self.model = model
        self.state = .download
        self.remoteDataService = remoteDataService
        self.fileService = fileService
        self.initData()
        self.bindInput()
    }

    func dowloadData() {
        Task {
            let fileFormat = model.title.components(separatedBy: ".").last ?? ""
            guard let data = await remoteDataService.downloadWithBytes(url: model.url)?.0,
                  let savedUrl = await self.fileService.saveFile(
                    name: getFileName(),
                    data: data,
                    pathExtension: fileFormat
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
                self.dataUrl = savedUrl
                self.state = .hasBeenDownloaded
            }
        }
    }

    // MARK: - Private Methods

    private func initData() {
        Task {
            let fileSize = self.convertToBytes(model.size)
            await MainActor.run {
                self.sizeOfFile = fileSize
                self.size = fileSize
            }

            let fileFormat = model.title.components(separatedBy: ".").last ?? ""
            let fileName = getFileName()
            let (isExist, path) = await fileService.checkFileExist(
                name: fileName,
                pathExtension: fileFormat
            )

            guard isExist else { return }

            await MainActor.run {
                self.dataUrl = path
                self.state = .hasBeenDownloaded
            }
        }
    }

    private func convertToBytes(_ value: Int) -> String {
        return Units(bytes: Int64(value)).getReadableUnit()
    }

    private func getFileName() -> String {
        let finalFileName = model.url.absoluteString.components(separatedBy: "/").last ?? ""
        return finalFileName
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
                        self.savedData = value
                        self.size = "\(bytes) / \(self.sizeOfFile)"
                    }
                }
            }
            .store(in: &subscriptions)
    }
}
