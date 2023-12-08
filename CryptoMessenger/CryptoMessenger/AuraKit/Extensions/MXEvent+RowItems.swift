import MatrixSDK

extension MXEvent {
    
    func message(_ isFromCurrentUser: Bool) -> RoomMessage? {
        
        switch eventType {
            case .roomMessage:
                return rowItem(isFromCurrentUser)
            case .roomEncrypted:
                return encryptedRowItem(isFromCurrentUser)
            case .callHangup, .callReject, .custom, .roomAvatar, .roomCreate, .roomMember:
                return rowItem(isFromCurrentUser)
            default:
                return nil
        }
    }
    
    // MARK: - Private Methods
    
    private func rowItem(_ isFromCurrentUser: Bool) -> RoomMessage {
        .init(
            id: eventId,
            sender: sender,
            type: messageType,
            shortDate: timestamp.hoursAndMinutes,
            fullDate: timestamp.dayOfWeekDayAndMonth,
            isCurrentUser: isFromCurrentUser,
            isReply: isReply(),
            replyDescription: replyDescription,
            audioDuration: audioDuration,
            content: content,
            eventType: type
        )
    }
    
    private func encryptedRowItem(_ isFromCurrentUser: Bool) -> RoomMessage {
        // TODO: Проверить как работает на расшифрованных сообщениях
        let type: MessageType
        if clear == nil {
            type = .text("Не удалось расшифровать сообщение")
        } else {
            type = .text(decryptedText())
        }
        
        let roomMessage = RoomMessage(
            id: eventId,
            sender: sender,
            type: type,
            shortDate: timestamp.hoursAndMinutes,
            fullDate: timestamp.dayOfWeekDayAndMonth,
            isCurrentUser: isFromCurrentUser,
            isReply: isReply(),
            replyDescription: replyDescription,
            content: content,
            eventType: self.type
        )
        return roomMessage
    }
}
