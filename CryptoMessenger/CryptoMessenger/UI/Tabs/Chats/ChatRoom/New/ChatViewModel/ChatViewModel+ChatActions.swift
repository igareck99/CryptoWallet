import Combine
import Foundation
import SwiftUI

extension ChatViewModel {
    func showChatRoomMenu() {
        let model = ActionsViewModel(
            interlocutorId: opponentId(),
            tappedAction: { [weak self] action in
                guard let self = self else { return }
                self.onTapped(action: action)
            },
            onCamera: { [weak self] in
                guard let self = self else { return }
                self.coordinator.galleryPickerSheet(
                    sourceType: .camera,
                    galleryContent: .all,
                    onSelectImage: { [weak self] image in
                        guard let image = image else { return }
                        self?.sendMessage(type: .image, image: image)
                    },
                    onSelectVideo: { [weak self] url in
                        guard let self = self, let url = url else { return }
                        self.sendMessage(type: .video, url: url)
                        self.sendVideo(
                            url,
                            self.makeOutputEventView(.video(url))
                        )
                    }
                )
            },
            onSendPhoto: { [weak self] image in
                guard let self = self else { return }
                self.sendMessage(type: .image, image: image)
                self.coordinator.dismissCurrentSheet()
            }
        )
        self.coordinator.chatMenu(model: model)
    }
}

// MARK: - Tapped Action

extension ChatViewModel {
    func onTapped(action: AttachAction) {
        switch action {
        case .media:
            onMediaTap()
        case .contact:
            onContactTap()
        case .document:
            onDocumentTap()
        case .location:
            onLocationTap()
        case let .moneyTransfer(receiverWallet):
            onCryptoSendTap(receiverWallet: receiverWallet)
        default:
            break
        }
    }

    // MARK: - Media

    func onMediaTap() {
        self.coordinator.galleryPickerSheet(
            sourceType: .photoLibrary,
            galleryContent: .all,
            onSelectImage: { [weak self] image in
                guard let self = self, let image = image else { return }
                self.sendMessage(type: .image, image: image)
            },
            onSelectVideo: { [weak self] url in
                guard let self = self, let url = url else { return }
                self.sendMessage(type: .video, url: url)
            }
        )
    }

    // MARK: - Contact

    func onContactTap() {
        self.coordinator.showSelectContact(
            mode: .send,
            chatData: Binding(
                get: { self.chatData },
                set: { value in self.chatData = value }
            ),
            contactsLimit: 1,
            onUsersSelected: { [weak self] contacts in
                guard let self = self else { return }
                contacts.forEach {
                    self.sendMessage(type: .contact, contact: $0)
                }
            }
        )
    }

    // MARK: - Document

    func onDocumentTap() {
        self.coordinator.presentDocumentPicker(
            onCancel: { [weak self] in
                guard let self = self else { return }
                self.coordinator.dismissCurrentSheet()
            },
            onDocumentsPicked: { [weak self] url in
                guard let self = self else { return }
                url.forEach {
                    self.sendMessage(type: .file, url: $0)
                }
            }
        )
    }

    // MARK: - Location

    func onLocationTap() {
        self.coordinator.presentLocationPicker(
            place: Binding(
                get: { self.location },
                set: { value in self.location = value ?? .zero }
            ),
            sendLocation: Binding(
                get: { self.isSendLocation },
                set: { value in self.isSendLocation = value }
            ),
            onSendPlace: { [weak self] place in
                guard let self = self else { return }
                let data = LocationData(lat: place.latitude, long: place.longitude)
                self.sendMessage(type: .location, location: data)
            }
        )
    }
}
