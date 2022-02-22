import Combine
import SwiftUI

// MARK: - ProfileItem

struct ProfileItem: Identifiable {

    // MARK: - Internal Properties

    let id = UUID()
    var avatar: URL?
    var name = "Имя не заполнено"
    var nickname = ""
    var status = "Всем привет! Я использую AURA!"
    var info = ""
    var phone = "Номер не заполнен"
    var photos: [Image] = []
    var photosUrls: [MediaURL] = []
    var socialNetwork: [SocialKey: String] = [:]
}

// MARK: - ProfileViewModel

final class ProfileViewModel: ObservableObject {

    // MARK: - Internal Properties

    weak var delegate: ProfileSceneDelegate?

    @Published var selectedImage: UIImage?

    // MARK: - Private Properties

    @Published var profile = ProfileItem()
    @Published private(set) var state: ProfileFlow.ViewState = .idle
    @Published private(set) var socialList = SocialListViewModel()
    @Published private(set) var socialListEmpty = true
    private let eventSubject = PassthroughSubject<ProfileFlow.Event, Never>()
    private let stateValueSubject = CurrentValueSubject<ProfileFlow.ViewState, Never>(.idle)
    private var subscriptions = Set<AnyCancellable>()

    @Injectable private var apiClient: APIClientManager
    @Injectable private(set) var mxStore: MatrixStore
    @Injectable private var userCredentialsStorageService: UserCredentialsStorageService

    // MARK: - Lifecycle

    init() {
        bindInput()
        bindOutput()
    }

    deinit {
        subscriptions.forEach { $0.cancel() }
        subscriptions.removeAll()
    }

    // MARK: - Internal Methods

    func send(_ event: ProfileFlow.Event) {
        eventSubject.send(event)
    }

    func deletePhoto(url: String) {
        apiClient.publisher(Endpoints.Media.deletePhoto([url]))
            .sink(receiveCompletion: { completion in
                switch completion {
                default:
                    break
                }
            }, receiveValue: { [weak self] _ in
                self?.profile.photosUrls = self?.profile.photosUrls
                    .filter { $0.previewURL.absoluteString != url } ?? []
            })
            .store(in: &subscriptions)
    }

    func addSocial(socialKey: SocialKey, socialValue: String) {
        var newDict = Dictionary(uniqueKeysWithValues:
                                    self.profile.socialNetwork.map { key, value in (key.rawValue,
                                                                    value) })
        newDict[socialKey.rawValue] = socialValue
        apiClient.publisher(Endpoints.Social.set_social(newDict, user: mxStore.getUserId()))
            .replaceError(with: [:])
            .sink { [weak self] dictionary in
                let result = dictionary.reduce([:]) { (partialResult: [SocialKey: String],
                                                       tuple: (key: String, value: String)) in
                    var result = partialResult
                    if let key = SocialKey(rawValue: tuple.key.lowercased()) {
                        result[key] = tuple.value.lowercased()
                        if !(result[key]?.isEmpty ?? true) {
                            self?.socialListEmpty = false
                        }
                    }
                    return result
                }
                self?.profile.socialNetwork = result
                self?.objectWillChange.send()
            }
            .store(in: &subscriptions)
    }

    // MARK: - Private Methods

    private func bindInput() {
        eventSubject
            .sink { [weak self] event in
                switch event {
                case .onAppear:
                    self?.updateData()
                    self?.objectWillChange.send()
                case .onProfileScene:
                    self?.delegate?.handleNextScene(.profileDetail)
                case .onPersonalization:
                    self?.delegate?.handleNextScene(.personalization)
                case .onSecurity:
                    self?.delegate?.handleNextScene(.security)
                case .onAboutApp:
                    self?.delegate?.handleNextScene(.aboutApp)
                case .onChatSettings:
                    self?.delegate?.handleNextScene(.chatSettings)
                case .onFAQ:
                    self?.delegate?.handleNextScene(.FAQ)
                case let .onAddPhoto(image):
                    self?.profile.photos.append(Image(uiImage: image))
                }
            }
            .store(in: &subscriptions)

        $selectedImage
            .receive(on: DispatchQueue.main)
            .sink { [weak self] image in
                guard let image = image else { return }
                self?.send(.onAddPhoto(image))
            }
            .store(in: &subscriptions)

        mxStore.objectWillChange
            .receive(on: DispatchQueue.main)
            .sink { _ in

            }
            .store(in: &subscriptions)
    }

    private func bindOutput() {
        stateValueSubject
            .assign(to: \.state, on: self)
            .store(in: &subscriptions)
    }

    private func getPhotos() {
        apiClient.publisher(Endpoints.Media.getPhotos(mxStore.getUserId()))
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    print(error)
                    return
                default:
                    break
                }
            }, receiveValue: { [weak self] response in
                self?.profile.photosUrls = []
                for media in response {
                    guard let originalURL = URL(string: media.original) else { return }
                    guard let previewURL = URL(string: media.preview) else { return }
                    self?.profile.photosUrls.append(MediaURL(originalURL: originalURL,
                                                             previewURL: previewURL))
                }
            })
            .store(in: &subscriptions)
    }

    func addPhoto(image: UIImage) {
        guard let data = image.pngData() else { return }
        let multipartData = MultipartFileData(file: "photo",
                                              mimeType: "image/png",
                                              fileData: data)
        apiClient.publisher(Endpoints.Media.upload(multipartData, name: mxStore.getUserId()))
            .sink(receiveCompletion: { completion in
                switch completion {
                default:
                    break
                }
            }, receiveValue: { [weak self] response in
                guard let original = response["original"] else { return }
                guard let preview = response["preview"] else { return }
                guard let originalUrl = URL(string: original) else { return }
                guard let previewUrl = URL(string: preview) else { return }
                self?.profile.photosUrls.insert(MediaURL(
                    originalURL: originalUrl,
                    previewURL: previewUrl), at: 0)
                self?.objectWillChange.send()
            })
            .store(in: &subscriptions)
    }

    func getSocialList() {
        apiClient.publisher(Endpoints.Social.getSocial(mxStore.getUserId()))
            .replaceError(with: [:])
            .sink { [weak self] dictionary in
                let result = dictionary.reduce([:]) { (partialResult: [SocialKey: String],
                                                       tuple: (key: String, value: String)) in
                    var result = partialResult
                    if let key = SocialKey(rawValue: tuple.key.lowercased()) {
                        result[key] = tuple.value.lowercased()
                        if !(result[key]?.isEmpty ?? true) {
                            self?.socialListEmpty = false
                        }
                    }
                    return result
                }
                self?.profile.socialNetwork = result
            }
            .store(in: &subscriptions)
    }

    private func updateData() {
        getSocialList()
        profile.nickname = mxStore.getUserId()
        if !mxStore.getDisplayName().isEmpty {
            profile.name = mxStore.getDisplayName()
        }
        if !mxStore.getStatus().isEmpty {
            profile.status = mxStore.getStatus()
        }
        profile.phone = userCredentialsStorageService.userPhoneNumber
        getPhotos()
    }
}

// MARK: - SocialKey

enum SocialKey: String, Identifiable, CaseIterable {

    // MARK: - Internal Properties

    var id: UUID { UUID() }

    // MARK: - Types

    case facebook, vk, twitter, instagram
}

// MARK: - MediaResponse

struct MediaResponse: Codable {

    // MARK: - Internal Properties

    var original: String
    var preview: String

    // MARK: - CodingKeys

    enum CodingKeys: String, CodingKey {

        // MARK: - Types

        case original
        case preview
    }
}

// MARK: - MediaURL

struct MediaURL: Codable {

    // MARK: - Internal Properties

    var originalURL: URL
    var previewURL: URL
}
