import Foundation

// MARK: - ChatViewModel

extension ChatViewModel {

    func sendPhoto(_ image: UIImage, _ event: RoomEvent) {
        inputText = ""
        mediaService.uploadChatPhoto(roomId: room.roomId,
                                     image: image) { result in
            switch result {
            case let .success(eventId):
                guard let eventId = eventId else { return }
                self.changeSedingEvent(event, .sentLocaly, eventId)
            case .failure(_):
                self.changeSedingEvent(event, .failToSend)
            }
        }
    }

    func sendVideo(_ url: URL, _ event: RoomEvent) {
        let mxImage = MXImage(systemName: "eraser")
        self.mediaService.uploadVideoMessage(for: room.roomId,
                                             url: url,
                                             thumbnail: mxImage) { result in
            switch result {
            case let .success(eventId):
                guard let eventId = eventId else { return }
                self.changeSedingEvent(event, .sentLocaly, eventId)
            case .failure(_):
                self.changeSedingEvent(event, .failToSend)
            }
        }
    }
    
    func sendContact(_ contact: Contact, _ event: RoomEvent) {
        self.mediaService.uploadChatContact(roomId: room.roomId,
                                            contact: contact) { result in
            switch result {
            case let .success(eventId):
                guard let eventId = eventId else { return }
                self.changeSedingEvent(event, .sentLocaly, eventId)
            case .failure(_):
                self.changeSedingEvent(event, .failToSend)
            }
        }
    }
    
    func sendMap(_ location: LocationData?, _ event: RoomEvent) {
        self.matrixUseCase.sendLocation(roomId: room.roomId,
                                        location: location) { result in
            switch result {
            case let .success(eventId):
                guard let eventId = eventId else { return }
                self.changeSedingEvent(event, .sentLocaly, eventId)
            case .failure(let error):
                self.changeSedingEvent(event, .failToSend)
            }
        }
    }
    
    func sendFile(_ url: URL, _ event: RoomEvent) {
        self.mediaService.uploadChatFile(roomId: self.room.roomId,
                                         url: url) { result in
            switch result {
            case let .success(eventId):
                guard let eventId = eventId else { return }
                self.changeSedingEvent(event, .sentLocaly, eventId)
            case .failure(_):
                self.changeSedingEvent(event, .failToSend)
            }
        }
    }
    
    func sendText() {
        switch quickAction {
        case .reply:
            guard let activeEditMessage = activeEditMessage else { return }
            let event = self.makeOutputEventView(.text(inputText), true)
            matrixUseCase.sendReply(activeEditMessage, inputText, completion: { result in
                switch result {
                case let .success(eventId):
                    guard let eventId = eventId else { return }
                    self.changeSedingEvent(event, .sentLocaly, eventId)
                case .failure(_):
                    self.changeSedingEvent(event, .failToSend)
                }
            })
            self.activeEditMessage = nil
            quickAction = nil
            self.inputText = ""
        case .edit:
            guard let activeEditMessage = activeEditMessage else { return }
            matrixUseCase.edit(roomId: room.roomId, text: inputText,
                               eventId: activeEditMessage.eventId)
            self.activeEditMessage = nil
            quickAction = nil
            self.inputText = ""
        default:
            let event = self.makeOutputEventView(.text(inputText))
            matrixUseCase.sendText(room.roomId,
                                   inputText,
                                   completion: { result in
                switch result {
                case let .success(eventId):
                    guard let eventId = eventId else { return }
                    self.changeSedingEvent(event, .sentLocaly, eventId)
                case let .failure(result):
                    self.changeSedingEvent(event, .failToSend)
                }
            })
        }
        activeEditMessage = nil
        quickAction = nil
        self.inputText = ""
    }

    func sendAudio(_ record: RecordingDataModel,
                   _ event: RoomEvent) {
        mediaService.uploadVoiceMessage(roomId: room.roomId,
                                        audio: record.fileURL,
                                        duration: UInt(record.duration)) { result in
            switch result {
            case let .success(eventId):
                guard let eventId = eventId else { return }
                self.changeSedingEvent(event, .sentLocaly, eventId)
            case .failure(_):
                self.changeSedingEvent(event, .failToSend)
            }
        }
    }
}
