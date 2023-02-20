import UIKit
import Combine

protocol MediaServiceProtocol {
    func downloadChatImages(roomId: String,
                            completion: @escaping ([URL]) -> Void)
    func downloadChatFiles(roomId: String,
                           completion: @escaping ([FileData]) -> Void)
    func downloadChatUrls(roomId: String,
                          completion: @escaping ([URL]) -> Void)
    func downloadAvatarUrl(completion: @escaping (URL?) -> Void)
    func addPhotoFeed(image: UIImage, userId: String, completion: @escaping (URL?) -> Void)
    func deletePhotoFeed(url: String, completion: @escaping (URL?) -> Void)
    func getPhotoFeedPhotos(userId: String, completion: @escaping ([URL]) -> Void)
    func uploadChatPhoto(roomId: String, image: UIImage, completion: @escaping (String?) -> Void)
    func uploadChatFile(roomId: String, url: URL, completion: @escaping (String?) -> Void)
    func uploadChatContact(roomId: String, contact: Contact,
                           completion: @escaping (String?) -> Void)
    func uploadVoiceMessage(roomId: String, audio: URL, duration: UInt, completion: @escaping (String?) -> Void)
    func uploadVideoMessage(for roomId: String,
                            url: URL,
                            thumbnail: MXImage?,
                            completion: @escaping (String?) -> Void)
}

enum MediaServiceError: Error {
    case roomError
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

    func downloadChatImages(roomId: String,
                            completion: @escaping ([URL]) -> Void) {
        guard let room = self.matrixService.rooms.first(where: { $0.room.roomId == roomId })
        else { return }
        var data: [URL] = []
        for item in room.events().renderableEvents {
            switch item.messageType {
            case let .image(url):
                guard let imageUrl = url else { break }
                data.append(imageUrl)
            default:
                completion([])
            }
        }
        completion(data)
    }

    func downloadChatFiles(roomId: String,
                           completion: @escaping ([FileData]) -> Void) {
        guard let room = self.matrixService.rooms.first(where: { $0.room.roomId == roomId })
        else { return }
        var data: [FileData] = []
        for item in room.events().renderableEvents {
            switch item.messageType {
            case let .file(fileName, url):
                guard let fileUrl = url else { break }
                let fileData = FileData(fileName: fileName,
                                        url: fileUrl,
                                        date: item.timestamp)
                data.append(fileData)
            default:
                break
            }
        }
        completion(data)
    }

    func downloadChatUrls(roomId: String,
                          completion: @escaping ([URL]) -> Void) {
        var data = [URL]()
        guard let room = self.matrixService.rooms.first(where: { $0.room.roomId == roomId })
                        else { return }
        for input in room.events().renderableEvents {
            do {
                switch input.messageType {
                case let .text(string):
                    let detector = try NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
                    let matches = detector.matches(in: string,
                                                   options: [],
                                                   range: NSRange(location: 0,
                                                                  length: string.utf16.count))
                    for match in matches {
                        guard let range = Range(match.range, in: string) else { continue }
                        let url = string[range]
                        guard let url = URL(string: string) else { return }
                        data.append(url)
                    }
                default:
                    break
                }
            } catch {
                completion(data)
            }
        }
        completion(data)
    }

    // MARK: - Chat

    func uploadVoiceMessage(roomId: String,
                            audio: URL,
                            duration: UInt,
                            completion: @escaping (String?) -> Void) {
        matrixService.uploadVoiceMessage(for: roomId,
                                         url: audio,
                                         duration: duration) { result in
            switch result {
            case let .success(eventId):
                completion(eventId)
            case let .failure(error):
                completion(nil)
            }
        }
    }

    func uploadChatPhoto(roomId: String,
                         image: UIImage,
                         completion: @escaping (String?) -> Void) {
        matrixService.uploadImage(for: roomId,
                                  image: image) { result in
            switch result {
            case let .success(eventId):
                completion(eventId)
            default:
                break
            }
        }
    }

    func uploadChatFile(roomId: String,
                        url: URL,
                        completion: @escaping (String?) -> Void) {
        matrixService.uploadFile(for: roomId,
                                 url: url) { result in
            switch result {
            case let .success(eventId):
                completion(eventId)
            default:
                break
            }
        }
    }

    func uploadChatContact(roomId: String, contact: Contact,
                           completion: @escaping (String?) -> Void) {
        matrixService.uploadContact(for: roomId,
                                    contact: contact) { result in
            switch result {
            case let .success(eventId):
                completion(eventId)
            default:
                break
            }
        }
    }

    func uploadVideoMessage(for roomId: String,
                            url: URL,
                            thumbnail: MXImage?,
                            completion: @escaping (String?) -> Void) {
        matrixService.uploadVideoMessage(for: roomId,
                                         url: url,
                                         thumbnail: thumbnail) { result in
            switch result {
            case let .success(eventId):
                completion(eventId)
            default:
                break
            }
        }
    }
}
