import SwiftUI
import Combine
import MatrixSDK

// MARK: - ChatMediaDelegate

protocol ChatMediaDelegate: ObservableObject {

    var sources: ChannelMediaSourcesable.Type { get }

}

// MARK: - ChannelMediaViewModel

final class ChannelMediaViewModel: ObservableObject {

    // MARK: - Internal Properties

    weak var delegate: ChannelMediaSceneDelegate?
    let resources: ChannelMediaSourcesable.Type
    @Published var photos: [URL] = []
    @Published var files: [FileData] = []
    @Published var links: [URL] = []
    @Published var selectedPhoto: URL?
    @Published var selectedFile: FileData
    @Published var documentViewModel: DocumentViewerViewModel?
    var room: AuraRoomData

    // MARK: - Private Properties

    private var subscriptions = Set<AnyCancellable>()
    @Injectable private(set) var matrixUseCase: MatrixUseCaseProtocol
    private var mediaService: MediaServiceProtocol

    // MARK: - Lifecycle

    init(room: AuraRoomData,
         resources: ChannelMediaSourcesable.Type = ChannelMediaSources.self,
         mediaService: MediaServiceProtocol = MediaService()) {
        self.resources = resources
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
        mediaService.downloadChatImages(roomId: room.roomId) { urls in
            self.photos = urls
        }
        mediaService.downloadChatFiles(roomId: room.roomId) { files in
            self.files = files
        }
        mediaService.downloadChatUrls(roomId: room.roomId) { urls in
            self.links = urls
        }
    }
}

