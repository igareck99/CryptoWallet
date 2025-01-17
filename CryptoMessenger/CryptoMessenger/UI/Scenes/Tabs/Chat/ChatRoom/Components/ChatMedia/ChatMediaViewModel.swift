import SwiftUI
import Combine

// MARK: - ChatMediaDelegate

protocol ChatMediaDelegate: ObservableObject {

    var sources: ChatMediaSourcesable.Type { get }

}

// MARK: - ChatMediaViewModel

final class ChatMediaViewModel: ObservableObject {

    // MARK: - Internal Properties

    weak var delegate: ChatMediaSceneDelegate?
    let sources: ChatMediaSourcesable.Type
    @Published var photos: [URL] = []
    @Published var files: [FileData] = []
    @Published var links: [URL] = []
    @Published var selectedPhoto: URL?
    @Published var selectedFile: FileData
    @Published var documentViewModel: DocumentViewerViewModel?
    var room: AuraRoom

    // MARK: - Private Properties

    private var subscriptions = Set<AnyCancellable>()
    @Injectable private(set) var matrixUseCase: MatrixUseCaseProtocol
    private var mediaService: MediaServiceProtocol

    // MARK: - Lifecycle

    init(room: AuraRoom,
         sources: ChatMediaSourcesable.Type = ChatMediaSources.self,
         mediaService: MediaServiceProtocol = MediaService()) {
        self.sources = sources
        self.room = room
        self.mediaService = mediaService
        self.selectedFile = FileData(fileName: "", url: URL(string: "test"), date: Date())
        updateData()
    }

    deinit {
        subscriptions.forEach { $0.cancel() }
        subscriptions.removeAll()
    }

    // MARK: - Private Methods

    private func updateData() {
        guard let id = room.room.roomId else { return }
        mediaService.downloadChatImages(roomId: id) { urls in
            self.photos = urls
        }
        mediaService.downloadChatFiles(roomId: id) { files in
            self.files = files
        }
        mediaService.downloadChatUrls(roomId: id) { urls in
            self.links = urls
        }
    }
}
