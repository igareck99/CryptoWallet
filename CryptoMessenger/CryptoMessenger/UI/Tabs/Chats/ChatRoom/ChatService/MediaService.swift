import Combine
import UIKit
import MatrixSDK

// MARK: - MediaServiceProtocol

protocol MediaServiceProtocol {
    func downloadChatImages(roomId: String) async -> [URL]
    func downloadChatFiles(roomId: String) async -> [FileData]
    func downloadChatUrls(roomId: String) async -> [URL]
    func downloadAvatarUrl(completion: @escaping (URL?) -> Void)
    func addPhotoFeed(image: UIImage, userId: String, completion: @escaping (URL?) -> Void)
    func deletePhotoFeed(url: String, completion: @escaping (URL?) -> Void)
    func getPhotoFeedPhotos(userId: String, completion: @escaping ([URL]) -> Void)

    func uploadChatPhoto(
        roomId: String,
        image: UIImage,
        completion: @escaping (Result <String?, MediaServiceError>) -> Void
    )

    func uploadChatFile(
        roomId: String,
        url: URL,
        completion: @escaping (Result <String?, MediaServiceError>) -> Void
    )

    func uploadChatContact(
        roomId: String,
        contact: Contact,
        completion: @escaping (Result <String?, MediaServiceError>) -> Void
    )

    func uploadVoiceMessage(
        roomId: String,
        audio: URL,
        duration: UInt,
        completion: @escaping (Result <String?, MediaServiceError>) -> Void
    )

    func uploadVideoMessage(
        for roomId: String,
        url: URL,
        thumbnail: MXImage?,
        completion: @escaping (Result <String?, MediaServiceError>) -> Void
    )

    func downloadData(
        url: URL?,
        completion: @escaping (Data?) -> Void
    )
}

enum MediaServiceError: Error {
    case roomError
    case audioUploadError
    case videoUploadError
    case contactUploadError
    case fileUploadError
    case photoUploadError
}

// MARK: - MediaService

final class MediaService: ObservableObject, MediaServiceProtocol {

    // MARK: - Private Properties

    private let matrixService: MatrixServiceProtocol
    @Injectable private var apiClient: APIClientManager
    @Injectable private var matrixUseCase: MatrixUseCaseProtocol
    private let config: ConfigType
    private var subscriptions = Set<AnyCancellable>()

    init(
        matrixService: MatrixServiceProtocol = MatrixService.shared,
        config: ConfigType = Configuration.shared
    ) {
        self.matrixService = matrixService
        self.config = config
    }

    // MARK: - Internal Methods

    func downloadAvatarUrl(completion: @escaping (URL?) -> Void) {
        matrixService.getAvatarUrl { [weak self] link in
            guard let self = self else { return }
            let homeServer = self.config.matrixURL
            let avatarUrl = MXURL(mxContentURI: link)?.contentURL(on: homeServer)
            completion(avatarUrl)
        }
    }

    func addPhotoFeed(image: UIImage, userId: String, completion: @escaping (URL?) -> Void) {
        guard let data = image.jpeg(.medium) else { return }
        let multipartData = MultipartFileData(
            file: "photo",
            mimeType: "image/png",
            fileData: data
        )
        apiClient.publisher(Endpoints.Media.upload(multipartData, name: userId))
            .sink { result in
                switch result {
                case .failure(let error):
                    completion(nil)
                    // TODO: Обработать Logout внутри API Client
//                    if let err = error as? APIError, err == .invalidToken {
//                        self?.matrixUseCase.logoutDevices { _ in
//                            // TODO: Обработать результат
//                        }
//                    }
                default:
                    break
                }
            } receiveValue: { response in
                completion(response.original)
            }
            .store(in: &subscriptions)
    }

    func downloadData(
        url: URL?,
        completion: @escaping (Data?) -> Void
    ) {
        guard let url = url else {
            completion(nil)
            return
        }
        do {
            if let data = try? Data(contentsOf: url) {
                completion(data)
            }
        } catch {
            completion(nil)
        }
    }

    func getPhotoFeedPhotos(userId: String, completion: @escaping ([URL]) -> Void) {
        apiClient.publisher(Endpoints.Media.getPhotos(userId))
            .sink {  result in
                switch result {
                case .failure(let error):
                    completion([])
                    // TODO: Обработать Logout внутри API Client
//                    if let err = error as? APIError, err == .invalidToken {
//                        self?.matrixUseCase.logoutDevices { _ in
//                            // TODO: Обработать результат
//                        }
//                    }
                default:
                    break
                }
            } receiveValue: { response in
                let urls: [URL] = response.compactMap { $0.original }
                completion(urls)
            }
            .store(in: &subscriptions)
    }

    func deletePhotoFeed(url: String, completion: @escaping (URL?) -> Void) {
        apiClient.publisher(Endpoints.Media.deletePhoto([url]))
            .sink(receiveCompletion: { result in
                switch result {
                case .failure(_):
                    completion(nil)
                default:
                    break
                }
            }, receiveValue: { response in
                let url = URL(string: response[0])
                completion(url)
            })
            .store(in: &subscriptions)
    }

    // MARK: - ChatMedia

    func downloadChatImages(roomId: String) async -> [URL] {

        guard let room = self.matrixService.rooms.first(
            where: { $0.room.roomId == roomId }
        ) else {
            return []
        }

        let imageUrls: [URL] = room.events().renderableEvents.reduce(
            into: [URL]()
        ) { result, event in
            guard case let .image(url) = event.messageType,
                  let imageUrl = url else {
                return
            }
            result.append(imageUrl)
        }
        return imageUrls
    }

    func downloadChatFiles(roomId: String) async -> [FileData] {

        guard let room = self.matrixService.rooms.first(
            where: { $0.room.roomId == roomId }
        ) else {
            return []
        }

        let fileDatas: [FileData] = room.events().renderableEvents.reduce(into: [FileData]()) { result, event in
            guard case let .file(fileName, url) = event.messageType,
                  let fileUrl = url else {
                return
            }
            let fileData = FileData(
                fileName: fileName,
                url: fileUrl,
                date: event.timestamp
            )
            result.append(fileData)
        }

        return fileDatas
    }

    func downloadChatUrls(roomId: String) async -> [URL] {

        guard let room = self.matrixService.rooms.first(
            where: { $0.room.roomId == roomId }
        ) else {
            return []
        }

        let chatUrls: [URL] = room.events().renderableEvents.reduce(into: [URL]()) { result, event in
            guard case let .text(messageText) = event.messageType,
                  let detector = try? NSDataDetector(
                    types: NSTextCheckingResult.CheckingType.link.rawValue
                  ) else {
                return
            }
            let range = NSRange(location: 0, length: messageText.utf16.count)
            let matches = detector.matches(in: messageText, options: [], range: range)
            matches.forEach { match in
                guard let range = Range(match.range, in: messageText) else { return }
                let url = messageText[range]
                guard let url = URL(string: messageText) else { return }
                result.append(url)
            }
        }
        return chatUrls
    }

    // MARK: - Chat

    func uploadVoiceMessage(roomId: String,
                            audio: URL,
                            duration: UInt,
                            completion: @escaping (Result <String?, MediaServiceError>) -> Void) {
        matrixService.uploadVoiceMessage(for: roomId,
                                         url: audio,
                                         duration: duration) { result in
            switch result {
            case let .success(eventId):
                completion(.success(eventId))
            case let .failure(error):
                completion(.failure(.audioUploadError))
            }
        }
    }

    func uploadChatPhoto(roomId: String,
                         image: UIImage,
                         completion: @escaping (Result <String?, MediaServiceError>) -> Void) {
        matrixService.uploadImage(for: roomId,
                                  image: image) { result in
            switch result {
            case let .success(eventId):
                completion(.success(eventId))
            case .failure(_):
                completion(.failure(.photoUploadError))
            }
        }
    }

    func uploadChatFile(roomId: String,
                        url: URL,
                        completion: @escaping (Result <String?, MediaServiceError>) -> Void) {
        matrixService.uploadFile(for: roomId,
                                 url: url) { result in
            switch result {
            case let .success(eventId):
                completion(.success(eventId))
            case .failure(_):
                completion(.failure(.fileUploadError))
            }
        }
    }

    func uploadChatContact(roomId: String, contact: Contact,
                           completion: @escaping (Result <String?, MediaServiceError>) -> Void) {
        matrixService.uploadContact(for: roomId,
                                    contact: contact) { result in
            switch result {
            case let .success(eventId):
                completion(.success(eventId))
            case .failure(_):
                completion(.failure(.contactUploadError))
            }
        }
    }

    func uploadVideoMessage(for roomId: String,
                            url: URL,
                            thumbnail: MXImage?,
                            completion: @escaping (Result <String?, MediaServiceError>) -> Void) {
        matrixService.uploadVideoMessage(for: roomId,
                                         url: url,
                                         thumbnail: thumbnail) { result in
            switch result {
            case let .success(eventId):
                completion(.success(eventId))
            case .failure(_):
                completion(.failure(.videoUploadError))
            }
        }
    }
}
