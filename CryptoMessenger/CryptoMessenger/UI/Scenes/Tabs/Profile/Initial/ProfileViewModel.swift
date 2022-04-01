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
    var socialNetwork: [SocialListItem] = []
}

// MARK: - ProfileViewModel

final class ProfileViewModel: ObservableObject {

    // MARK: - Internal Properties

    weak var delegate: ProfileSceneDelegate?

    @Published var selectedImage: UIImage?
    @Published var listData: [SocialListItem] = [
        SocialListItem(url: "",
                       sortOrder: 1,
                       socialType: .instagram),
        SocialListItem(url: "",
                       sortOrder: 2,
                       socialType: .facebook),
        SocialListItem(url: "",
                       sortOrder: 3,
                       socialType: .twitter),
        SocialListItem(url: "",
                       sortOrder: 4,
                       socialType: .vk),
        SocialListItem(url: "",
                       sortOrder: 5,
                       socialType: .tiktok),
        SocialListItem(url: "",
                       sortOrder: 6,
                       socialType: .linkedin)
    ]

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
        fetchData()
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

    // MARK: - Private Methods

    private func bindInput() {
        eventSubject
            .sink { [weak self] event in
                switch event {
                case .onAppear:
                    self?.fetchData()
                    self?.objectWillChange.send()
                case .onSocial:
                    self?.delegate?.handleNextScene(.socialList)
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
                        self?.delegate?.handleNextScene(.faq)
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
        $profile
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.objectWillChange.send()
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

    private func getSocialList() {
        apiClient.publisher(Endpoints.Social.getSocial(mxStore.getUserId()))
            .replaceError(with: [])
            .sink { [weak self] response in
                for x in response {
                    let newList = self?.listData.filter { $0.socialType.description != x.social_type } ?? []
                    if newList.count != self?.listData.count {
                        self?.listData = newList
                        self?.listData.append(SocialListItem(url: x.url,
                                                             sortOrder: x.sort_order,
                                                             socialType: SocialNetworkType.networkType(item: x.social_type)))
                    }
                }
                let sortedList = self?.listData.sorted(by: { $0.sortOrder < $1.sortOrder })
                self?.profile.socialNetwork = sortedList ?? []
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

    private func fetchData() {
        let link = mxStore.getAvatarUrl()
        let homeServer = Bundle.main.object(for: .matrixURL).asURL()
        let url = MXURL(mxContentURI: link)?.contentURL(on: homeServer)
        profile.avatar = url
        profile.nickname = mxStore.getUserId()
        if !mxStore.getDisplayName().isEmpty {
            profile.name = mxStore.getDisplayName()
        }
        if !mxStore.getStatus().isEmpty {
            profile.status = mxStore.getStatus()
        }
        getSocialList()
        profile.phone = userCredentialsStorageService.userPhoneNumber
        getPhotos()
        socialListEmpty = profile.socialNetwork.isEmpty
    }
}
