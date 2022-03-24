import Combine
import SwiftUI

// MARK: - SocialKey

enum SocialKey: String, Identifiable, CaseIterable {

    // MARK: - Internal Properties

    var id: UUID { UUID() }

    // MARK: - Types

    case facebook, vk, twitter, instagram
}

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
    var photosUrls: [URL] = []
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
    @Injectable private var mxStore: MatrixStore
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
                self?.profile.photosUrls.removeAll(where: { $0.absoluteString == url })
            })
            .store(in: &subscriptions)
    }

    func addSocial(socialKey: SocialKey, socialValue: String) {
        var newDict = Dictionary(uniqueKeysWithValues: profile.socialNetwork.map { key, value in (key.rawValue, value) })
        newDict[socialKey.rawValue] = socialValue
        apiClient.publisher(Endpoints.Social.setSocial(newDict, user: mxStore.getUserId()))
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

    // MARK: - Private Methods

    private func bindInput() {
        eventSubject
            .sink { [weak self] event in
                switch event {
                case .onAppear:
                    self?.fetchData()
                case let .onShow(type):
                    switch type {
                    case .profile:
                        self?.delegate?.handleNextScene(.profileDetail)
                    case .personalization:
                        self?.delegate?.handleNextScene(.personalization)
                    case .security:
                        self?.delegate?.handleNextScene(.security)
                    case .about:
                        self?.delegate?.handleNextScene(.aboutApp)
                    case .chat:
                        self?.delegate?.handleNextScene(.chatSettings)
                    case .questions:
                        self?.delegate?.handleNextScene(.FAQ)
                    case .wallet:
                        self?.delegate?.handleNextScene(.walletManager)
                    default:
                        ()
                    }
                case let .onAddPhoto(image):
                    self?.addPhoto(image: image)
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
            .subscribe(on: DispatchQueue.global(qos: .userInteractive))
            .receive(on: DispatchQueue.main)
            .sink { _ in }
            .store(in: &subscriptions)
    }

    private func bindOutput() {
        stateValueSubject
            .assign(to: \.state, on: self)
            .store(in: &subscriptions)
    }

    private func getPhotos() {
        apiClient.publisher(Endpoints.Media.getPhotos(mxStore.getUserId()))
            .replaceError(with: [])
            .sink { [weak self] response in
                self?.profile.photosUrls = response.compactMap { $0.original }
            }
            .store(in: &subscriptions)
    }

    func addPhoto(image: UIImage) {
        guard let data = image.jpeg(.medium) else { return }
        let multipartData = MultipartFileData(
            file: "photo",
            mimeType: "image/png",
            fileData: data
        )
        apiClient.publisher(Endpoints.Media.upload(multipartData, name: mxStore.getUserId()))
            .replaceError(with: .init())
            .sink { [weak self] response in
                guard let url = response.original else { return }
                self?.profile.photosUrls.insert(url, at: 0)
            }
            .store(in: &subscriptions)
    }

    func getSocialList() {
        apiClient.publisher(Endpoints.Social.getSocial(mxStore.getUserId()))
            .replaceError(with: [:])
            .sink { [weak self] dictionary in
                let result = dictionary.reduce([:]) { (partialResult: [SocialKey: String], tuple: (key: String, value: String)) in
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

    private func fetchData() {
        let link = mxStore.getAvatarUrl()
        let homeServer = Bundle.main.object(for: .matrixURL).asURL()
        let url = MXURL(mxContentURI: link)?.contentURL(on: homeServer)
        profile.avatar = url
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
