import Combine

// MARK: - SelectChannelTypeViewModel

final class SelectChannelTypeViewModel: ObservableObject {

    // MARK: - Internal Properties

    var roomId: String
    var isRoomPublic = false
    @Published var isPublicSelected = false
    @Published var isPrivateSelected = true
    @Published var isEncryptionEnabled = false
    let resources: SelectChannelTypeResourcable.Type

    // MARK: - Private Properties

    @Injectable private(set) var matrixUseCase: MatrixUseCaseProtocol

    // MARK: - Lifecycle

    init(
        roomId: String,
        resources: SelectChannelTypeResourcable.Type = SelectChannelTypeResources.self
    ) {
        self.resources = resources
        self.roomId = roomId
        updateSettings()
    }

    // MARK: - Internal Methods

    func updateSettings() {
        matrixUseCase.isRoomPublic(roomId: roomId) { value in
            guard let result = value else { return }
            self.isRoomPublic = result
            if self.isRoomPublic {
                self.isPublicSelected = true
            } else {
                self.isPrivateSelected = true
            }
            self.objectWillChange.send()
        }
    }

    func updateRoomState() {
        let value = isPublicSelected ? true : false
        if value != isRoomPublic {
            matrixUseCase.setRoomState(roomId: roomId,
                                       isPublic: value) { _ in
                self.updateSettings()
            }
        }
    }
}
