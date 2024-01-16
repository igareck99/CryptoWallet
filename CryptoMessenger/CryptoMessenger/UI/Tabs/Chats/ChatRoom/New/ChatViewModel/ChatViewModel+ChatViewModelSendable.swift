import Foundation

// MARK: - ChatViewModel

extension ChatViewModel {

    func sendPhoto(_ image: UIImage, _ event: RoomEvent) {
        inputText = ""
        mediaService.uploadChatPhoto(
            roomId: room.roomId,
            image: image
        ) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .success(eventId):
                guard let eventId = eventId else { return }
                guard let data = image.jpegData(compressionQuality: 1) else { return }
                Task {
                    await self.fileService.saveFile(name: eventId,
                                              data: data,
                                              pathExtension: "jpeg")
                    self.changeSedingEvent(
                        event: event,
                        state: .sentLocaly,
                        eventId: eventId
                    )
                }
            case .failure(_):
                self.changeSedingEvent(
                    event: event,
                    state: .failToSend
                )
            }
        }
    }

    func sendVideo(_ url: URL, _ event: RoomEvent) {
        let mxImage = MXImage(systemName: "eraser")
        self.mediaService.uploadVideoMessage(
            for: room.roomId,
            url: url,
            thumbnail: mxImage
        ) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .success(eventId):
                guard let eventId = eventId else { return }
                self.changeSedingEvent(
                    event: event,
                    state: .sentLocaly,
                    eventId: eventId
                )
            case .failure(_):
                self.changeSedingEvent(
                    event: event,
                    state: .failToSend
                )
        }
        }
    }

    func sendContact(_ contact: Contact, _ event: RoomEvent) {
        self.mediaService.uploadChatContact(
            roomId: room.roomId,
            contact: contact
        ) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .success(eventId):
                guard let eventId = eventId else { return }
                self.changeSedingEvent(
                    event: event,
                    state: .sentLocaly,
                    eventId: eventId
                )
            case .failure(_):
                self.changeSedingEvent(
                    event: event,
                    state: .failToSend
                )
            }
        }
    }

    func sendMap(_ location: LocationData?, _ event: RoomEvent) {
        self.matrixUseCase.sendLocation(
            roomId: room.roomId,
            location: location
        ) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .success(eventId):
                guard let eventId = eventId else { return }
                self.changeSedingEvent(
                    event: event,
                    state: .sentLocaly,
                    eventId: eventId
                )
            case .failure(let error):
                self.changeSedingEvent(
                    event: event,
                    state: .failToSend
                )
            }
        }
    }

    func sendFile(_ url: URL, _ event: RoomEvent) {
        self.mediaService.uploadChatFile(roomId: self.room.roomId,
                                         url: url) { result in
            switch result {
            case let .success(eventId):
                guard let eventId = eventId else { return }
                self.changeSedingEvent(
                    event: event,
                    state: .sentLocaly,
                    eventId: eventId
                )
            case .failure(_):
                self.changeSedingEvent(
                    event: event,
                    state: .failToSend
                )
            }
        }
    }
    
    func sendText() {
        switch quickAction {
        case .reply:
            guard let activeEditMessage = activeEditMessage else { return }
            let event = self.makeOutputEventView(.text(inputText), true)
            matrixUseCase.sendReply(
                activeEditMessage,
                inputText,
                completion: { [weak self] result in
                    guard let self = self else { return }
                    switch result {
                    case let .success(eventId):
                        guard let eventId = eventId else { return }
                        self.changeSedingEvent(
                            event: event,
                            state: .sentLocaly,
                            eventId: eventId
                        )
                        self.scrollToBottom()
                    case .failure(_):
                        self.changeSedingEvent(
                            event: event,
                            state: .failToSend
                        )
                    }
                }
            )
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
            self.scrollToBottom()
        default:
            let event = self.makeOutputEventView(.text(inputText))
            matrixUseCase.sendText(
                room.roomId,
                inputText,
                completion: { [weak self] result in
                    guard let self = self else { return }
                    switch result {
                    case let .success(eventId):
                        guard let eventId = eventId else { return }
                        self.changeSedingEvent(
                            event: event,
                            state: .sentLocaly,
                            eventId: eventId
                        )
                        self.scrollToBottom()
                    case let .failure(result):
                    self.changeSedingEvent(
                        event: event,
                        state: .failToSend
                    )
                    }
                }
            )
        }
        activeEditMessage = nil
        quickAction = nil
        self.inputText = ""
    }

    func sendAudio(
        record: RecordingDataModel,
        event: RoomEvent
    ) {
        mediaService.uploadVoiceMessage(
            roomId: room.roomId,
            audio: record.fileURL,
            duration: UInt(record.duration)
        ) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .success(eventId):
                guard let eventId = eventId else { return }
                self.changeSedingEvent(
                    event: event,
                    state: .sentLocaly,
                    eventId: eventId
                )
            case .failure(_):
                self.changeSedingEvent(
                    event: event,
                    state: .failToSend
                )
            }
        }
    }
}
