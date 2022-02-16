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
    var photosUrls: [MediaResponse] = []
    var social_list: [String: String] = [:]
    var photos_url_preview: [URL] = []
    var photos_url_original: [URL] = []
    var socialNetworks: SocialResponse?
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
    @Published private(set) var socialListKeys = ["facebook", "VK", "twitter", "instagram"]
    @Published private(set) var userSocials: [SocialKey: String] = [:]
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
            }, receiveValue: { [weak self] response in
                self?.profile.photosUrls = self?.profile.photosUrls
                    .filter { $0.photosUrlPreview.absoluteString != response[0] } ?? []
            })
            .store(in: &subscriptions)
    }

    func addSocial(social: [String: String]) {
        apiClient.publisher(Endpoints.Social.set_social(social, user: mxStore.getUserId()))
            .replaceError(with: [:])
            .sink { [weak self] dictionary in
                let result = dictionary.reduce([:]) { (partialResult: [SocialKey: String], tuple: (key: String, value: String)) in
                    var result = partialResult
                    if let key = SocialKey(rawValue: tuple.key.lowercased()) {
                        result[key] = tuple.value.lowercased()
                    }
                    return result
                }
                self?.userSocials = result // тут откидывается результат на UI
                self?.updateData()
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
                case .aboutApp:
                    self?.delegate?.handleNextScene(.aboutApp)
                case .onChatSettings:
                    self?.delegate?.handleNextScene(.chatSettings)
                case .onFAQ:
                    self?.delegate?.handleNextScene(.FAQ)
                }
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
                for x in response {
                    guard let original = x["original"] else { return }
                    guard let preview = x["preview"] else { return }
                    guard let original_url = URL(string: original) else { return }
                    guard let preview_url = URL(string: preview) else { return }
                    self?.profile.photosUrls.append(MediaResponse(photosUrlPreview: preview_url, photosUrlOriginal: original_url))
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
                guard let original_url = URL(string: original) else { return }
                guard let preview_url = URL(string: preview) else { return }
                print("original_url    \(original_url)")
                print("preview_url    \(preview_url)")
                self?.profile.photosUrls.insert(MediaResponse(photosUrlPreview: preview_url, photosUrlOriginal: original_url), at: 0)
                self?.objectWillChange.send()
            })
            .store(in: &subscriptions)
    }

    func getSocialList() {
        state = .idle
        apiClient.publisher(Endpoints.Social.get_social(mxStore.getUserId()))
            .replaceError(with: [:])
            .sink { [weak self] dictionary in
                let social = SocialResponse(facebook: dictionary["facebook"] ?? "",
                                            vk: dictionary["vk"] ?? "",
                                            twitter: dictionary["twitter"] ?? "",
                                            instagram: dictionary["instagram"] ?? "")
                self?.profile.socialNetworks = social // тут откидывается результат на UI
                print("dpledplelpd,cls \(self?.profile.socialNetworks)")
            }
            .store(in: &subscriptions)
    }

    private func updateData() {
        profile.nickname = mxStore.getUserId()
        if !mxStore.getDisplayName().isEmpty {
            profile.name = mxStore.getDisplayName()
        }
        if !mxStore.getStatus().isEmpty {
            profile.status = mxStore.getStatus()
        }
        if !mxStore.getAvatarUrl().isEmpty {
            profile.avatar = URL(fileURLWithPath: mxStore.getAvatarUrl())
        }
        profile.phone = userCredentialsStorageService.userPhoneNumber
        getPhotos()
        getSocialList()
        print("Result    \(profile.socialNetworks)")
    }
}

// MARK: - SocialKey

enum SocialKey: String, Identifiable, CaseIterable {

    // MARK: - Internal Properties

    var id: UUID { UUID() }

    // MARK: - Types

    case facebook, vk, twitter, instagram
}

// MARK: - SocialResponse

struct SocialResponse: Codable {

    // MARK: - Internal Properties

    var facebook: String = ""
    var vk: String = ""
    var twitter: String = ""
    var instagram: String = ""
}

// MARK: - MediaResponse

struct MediaResponse: Codable {

    // MARK: - Internal Properties

    var photosUrlPreview: URL
    var photosUrlOriginal: URL

}
