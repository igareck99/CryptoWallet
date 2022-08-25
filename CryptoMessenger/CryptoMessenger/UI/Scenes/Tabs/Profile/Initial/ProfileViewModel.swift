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
    @Published var changedImage: UIImage?
    @Published var selectedPhoto: URL?
    @Published var imageToShare: UIImage?
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
    @Published var profile = ProfileItem()
    @Published var existringUrls: [String] = []

    // MARK: - Private Properties

    @Published private(set) var state: ProfileFlow.ViewState = .idle
	@Published private(set) var socialList = SocialListViewModel()
    @Published private(set) var socialListEmpty = true
    private let eventSubject = PassthroughSubject<ProfileFlow.Event, Never>()
    private let stateValueSubject = CurrentValueSubject<ProfileFlow.ViewState, Never>(.idle)
    private var subscriptions = Set<AnyCancellable>()
    let mediaService = MediaService()
    @State private var showImageEdtior = false

    @Injectable private var apiClient: APIClientManager
    @Injectable private var matrixUseCase: MatrixUseCaseProtocol
    private let userSettings: UserCredentialsStorage & UserFlowsStorage
	private let keychainService: KeychainServiceProtocol

    // MARK: - Lifecycle

    init(
        userSettings: UserCredentialsStorage & UserFlowsStorage,
        keychainService: KeychainServiceProtocol
    ) {
		self.userSettings = userSettings
		self.keychainService = keychainService
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

    func updateFeedAfterDelete(url: URL?) {
        guard let unwrappedUrl = url else { return }
        profile.photosUrls = profile.photosUrls.filter { $0 != unwrappedUrl }
        self.objectWillChange.send()
    }

    // MARK: - Private Methods

    private func bindInput() {
        eventSubject
            .sink { [weak self] event in
                switch event {
                case .onProfileAppear:
                    self?.fetchData()
                case .onAppear:
                    self?.fetchImageData()
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
                    guard let userId = self?.matrixUseCase.getUserId() else { return }
                    self?.mediaService.addPhotoFeed(image: image,
                                                    userId: userId) { url in
                        guard let realUrl = url else { return }
                        self?.profile.photosUrls.insert(realUrl, at: 0)
                        self?.objectWillChange.send()
                    }
                }
            }
            .store(in: &subscriptions)
        $changedImage
            .receive(on: DispatchQueue.main)
            .sink { [weak self] image in
                guard let image = image else { return }
                self?.send(.onAddPhoto(image))
            }
            .store(in: &subscriptions)
        $selectedPhoto
            .receive(on: DispatchQueue.main)
            .sink { [weak self] url in
                DispatchQueue.global().async { [weak self] in
                    guard let uploadUrl = url else { return }
                    if let imageData = try? Data(contentsOf: uploadUrl) {
                        if let image = UIImage(data: imageData) {
                            DispatchQueue.main.async {
                                self?.imageToShare = image
                            }
                        }
                    }
                }
            }
            .store(in: &subscriptions)
		matrixUseCase.loginStatePublisher.sink { [weak self] status in
            switch status {
            case .loggedOut:
                self?.userSettings.isAuthFlowFinished = false
                self?.userSettings.isOnboardingFlowFinished = false
                self?.userSettings.isLocalAuth = false
                self?.keychainService.apiUserPinCode = ""
                self?.delegate?.restartFlow()
            default:
                break
            }
        }
        .store(in: &subscriptions)

		matrixUseCase.objectChangePublisher
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

    private func getSocialList() {
        apiClient.publisher(Endpoints.Social.getSocial(matrixUseCase.getUserId()))
            .sink { [weak self] completion in
                switch completion {
                case .failure(let error):
                    if let err = error as? APIError, err == .invalidToken {
						self?.matrixUseCase.logoutDevices { _ in
							// TODO: Обработать результат
						}
                    }
                default:
                    break
                }
            } receiveValue: { [weak self] response in
                for x in response {
                    let newList = self?.listData.filter { $0.socialType.description != x.socialType } ?? []
                    if newList.count != self?.listData.count {
                        self?.listData = newList
                        self?.listData.append(
                            .init(
                                url: x.url,
                                sortOrder: x.sortOrder,
                                socialType: SocialNetworkType.networkType(item: x.socialType)
                            )
                        )
                    }
                }
                guard let sortedList = self?.listData.sorted(by: { $0.sortOrder < $1.sortOrder })
                else { return }
                self?.profile.socialNetwork = sortedList
                self?.existringUrls = []
                for item in sortedList.filter({ !$0.url.isEmpty }) {
                    self?.existringUrls.append(item.url)
                }
                for x in sortedList {
                    if !x.url.isEmpty {
                        self?.socialListEmpty = false
                        break
                    } else {
                        self?.socialListEmpty = true
                    }
                }
            }
            .store(in: &subscriptions)
    }

    private func fetchData() {
        mediaService.downloadAvatarUrl(completion: { url in
            self.profile.avatar = url
        })
        profile.nickname = matrixUseCase.getUserId()
        if !matrixUseCase.getDisplayName().isEmpty {
            profile.name = matrixUseCase.getDisplayName()
        }
        if !matrixUseCase.getStatus().isEmpty {
            profile.status = matrixUseCase.getStatus()
        }
        mediaService.getPhotoFeedPhotos(userId: matrixUseCase.getUserId()) { urls in
            self.profile.photosUrls = urls
        }
        getSocialList()
		if let phoneNumber = keychainService.apiUserPhoneNumber {
			profile.phone = phoneNumber
		}
    }

    private func fetchImageData() {
        mediaService.downloadAvatarUrl(completion: { url in
            self.profile.avatar = url
        })
        profile.nickname = matrixUseCase.getUserId()
        if !matrixUseCase.getDisplayName().isEmpty {
            profile.name = matrixUseCase.getDisplayName()
        }
        if !matrixUseCase.getStatus().isEmpty {
            profile.status = matrixUseCase.getStatus()
        }
    }
}
