import Foundation
import SwiftUI

// MARK: - ChatViewModel(ChatEventsDelegate)

extension ChatViewModel: ChatEventsDelegate {

    func onContactEventTap(contactInfo: ChatContactInfo) {
        coordinator.onContactTap(contactInfo: contactInfo)
    }

    func onMapEventTap(place: Place) {
        coordinator.onMapTap(place: place)
    }

    func onImageTap(image: Image?, imageUrl: URL?) {
        coordinator.showImageViewer(image: image, imageUrl: imageUrl)
    }

    func onCallTap(roomId: String) {
        let contacts = [Contact]()
        self.p2pCallsUseCase.placeVoiceCall(
            roomId: roomId,
            contacts: contacts
        )
        self.updateToggles()
    }

    func onDocumentTap(fileUrl: URL, fileName: String) {
        coordinator.onDocumentTap(name: fileName, fileUrl: fileUrl)
    }

    func onVideoTap(url: URL) {
        coordinator.onVideoTap(url: url)
    }

    func onGroupCallTap(eventId: String) {
        self.groupCallsUseCase.joinGroupCallInRoom(
            eventId: eventId,
            roomId: self.room.roomId
        )
        self.updateToggles()
    }

    func didTapCryptoSend(event: RoomEvent) {
        let model: TransactionStatus = transactionStatusFactory.makeModel(event: event)
        coordinator.showTransactionStatus(model: model)
    }
}
