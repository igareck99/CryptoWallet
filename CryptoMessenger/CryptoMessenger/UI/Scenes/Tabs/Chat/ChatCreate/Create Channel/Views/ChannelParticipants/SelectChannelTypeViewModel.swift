import Combine

// MARK: - SelectChannelTypeViewModel

final class SelectChannelTypeViewModel: ObservableObject {
    
    var roomId: String
    var isRoomPublic = false
    @Published var isPublicSelected = false
    @Published var isPrivateSelected = false
    @Published var isEncryptionEnabled = false

    // MARK: - Private Properties

    @Injectable private(set) var matrixUseCase: MatrixUseCaseProtocol

    // MARK: - Lifecycle

    init(roomId: String) {
        self.roomId = roomId
        updateSettings()
    }

    // MARK: - Internal Methods

    func updateSettings() {
        matrixUseCase.isRoomPublic(roomId: roomId) { vbalue in
            guard let result = vbalue else { return }
            self.isRoomPublic = result
            print("skasыфщыфыщыklask  \(self.isRoomPublic)")
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
                                       isPublic: value) { result in
                print("skasklask  \(result)")
            }
        }
    }
}
