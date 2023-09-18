import Foundation

// MARK: - ChatViewModel

extension ChatViewModel {
    func sendAudio(_ record: RecordingDataModel) {
        mediaService.uploadVoiceMessage(roomId: room.roomId,
                                        audio: record.fileURL,
                                        duration: UInt(record.duration)) { _ in
            self.matrixUseCase.objectChangePublisher.send()
        }
    }

    func sendPhoto(_ image: UIImage) {
        inputText = ""
        mediaService.uploadChatPhoto(roomId: room.roomId,
                                     image: image) { _ in
            self.matrixUseCase.objectChangePublisher.send()
        }
    }

    func sendVideo(_ url: URL) {
        let mxImage = MXImage(systemName: "eraser")
        self.mediaService.uploadVideoMessage(for: room.roomId,
                                             url: url,
                                             thumbnail: mxImage,
                                             completion: { _ in
            self.matrixUseCase.objectChangePublisher.send()
        })
    }
    
    func sendContact(_ contact: Contact) {
        self.mediaService.uploadChatContact(roomId: room.roomId,
                                            contact: contact) { _ in
            self.matrixUseCase.objectChangePublisher.send()
        }
    }
    
    func sendMap(_ location: LocationData?) {
        self.matrixUseCase.sendLocation(roomId: room.roomId,
                                        location: location) { _ in
            self.matrixUseCase.objectChangePublisher.send()
        }
    }
    
    func sendFile(_ url: URL) {
        self.mediaService.uploadChatFile(roomId: self.room.roomId,
                                         url: url) { _ in
            
        }
    }
}
