import Foundation
import MatrixSDK

extension MatrixUseCase {
    func uploadVideoMessage(
        for roomId: String,
        url: URL,
        thumbnail: MXImage?,
        completion: @escaping (Result <String?, MXErrors>) -> Void
    ) {
        matrixService.uploadVideoMessage(
            for: roomId,
            url: url,
            thumbnail: thumbnail,
            completion: completion
        )
    }

    func uploadContact(
        for roomId: String,
        contact: Contact,
        completion: @escaping (Result <String?, MXErrors>) -> Void
    ) {
        matrixService.uploadContact(
            for: roomId,
            contact: contact,
            completion: completion
        )
    }

    func uploadFile(
        for roomId: String,
        url: URL,
        completion: @escaping (Result <String?, MXErrors>) -> Void
    ) {
        matrixService.uploadFile(
            for: roomId,
            url: url,
            completion: completion
        )
    }

    func uploadImage(
        for roomId: String,
        image: UIImage,
        completion: @escaping (Result <String?, MXErrors>) -> Void
    ) {
        matrixService.uploadImage(
            for: roomId,
            image: image,
            completion: completion
        )
    }

    func uploadVoiceMessage(
        for roomId: String,
        url: URL,
        duration: UInt,
        completion: @escaping (Result <String?, MXErrors>) -> Void
    ) {
        matrixService.uploadVoiceMessage(
            for: roomId,
            url: url, 
            duration: duration,
            completion: completion
        )
    }
}
