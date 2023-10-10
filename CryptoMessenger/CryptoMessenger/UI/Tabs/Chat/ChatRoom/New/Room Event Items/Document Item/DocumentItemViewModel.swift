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

    init(model: DocumentItem,
         remoteDataService: RemoteDataServiceProtocol = RemoteDataService.shared,
         fileService: FileManagerProtocol = FileManagerService.shared) {
        self.model = model
        self.state = .download
        self.remoteDataService = remoteDataService
        self.fileService = fileService
        self.initData()
        self.bindInput()
    }

    func dowloadData() {
        Task {
            let result = await remoteDataService.downloadWithBytes(url: model.url)
            let fileFormat = model.title.components(separatedBy: ".").last ?? ""
            guard let data = result?.0,
                  let savedUrl = self.fileService.saveFile(name: getFileName(),
                                                           data: data,
                                                           pathExtension: fileFormat) else {
                debugPrint("downloadDataRequest FAILED")
                await MainActor.run {
                    self.state = .download
                }
                return
            }
            await MainActor.run {
                self.size = savedUrl.fileSize()
                self.dataUrl = savedUrl
                self.state = .hasBeenDownloaded
            }
        }
    }

    // MARK: - Private Methods
    
    private func initData() {
        self.sizeOfFile = self.convertToBytes(model.size)
        self.size = self.sizeOfFile
        let fileFormat = model.title.components(separatedBy: ".").last ?? ""
        let (isExist, path) = fileService.checkFileExist(name: getFileName(), pathExtension: fileFormat)
        if isExist {
            DispatchQueue.main.async {
                self.dataUrl = path
                self.state = .hasBeenDownloaded
            }
        }
    }
    
    private func convertToBytes(_ value: Int) -> String {
        return Units(bytes: Int64(value)).getReadableUnit()
    }
    
    private func getFileName() -> String {
        let fileadressName = model.url.absoluteString.components(separatedBy: "/").last ?? ""
        let finalFileName = fileadressName
        return finalFileName
    }

    private func bindInput() {
        remoteDataService.dataSizePublisher
            .subscribe(on: DispatchQueue.global(qos: .default))
            .receive(on: DispatchQueue.global(qos: .default))
            .sink { [weak self] value in
                guard let self = self else { return }
                if self.state == .loading {
                    self.savedData = value
                    DispatchQueue.main.async {
                        self.size = "\(self.convertToBytes(value.savedBytes)) / \(self.sizeOfFile)"
                    }
                }
            }
            .store(in: &subscriptions)
    }
}
