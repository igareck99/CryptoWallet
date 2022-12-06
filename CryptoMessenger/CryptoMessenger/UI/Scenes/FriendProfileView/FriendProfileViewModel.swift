import Combine
import Foundation

// MARK: - FriendProfileViewModel

final class FriendProfileViewModel: ObservableObject {

    // MARK: - Internal Properties

    weak var delegate: FriendProfileSceneDelegate?

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
    var p2pVideoCallPublisher = ObservableObjectPublisher()
    let mediaService = MediaService()
    @Published var userId: Contact

    // MARK: - Private Properties

    @Published private(set) var state: FriendProfileFlow.ViewState = .idle
    @Published private(set) var socialList = SocialListViewModel()
    @Published private(set) var socialListEmpty = true
    private let eventSubject = PassthroughSubject<FriendProfileFlow.Event, Never>()
    private let stateValueSubject = CurrentValueSubject<FriendProfileFlow.ViewState, Never>(.idle)
    private var subscriptions = Set<AnyCancellable>()

    @Injectable private var apiClient: APIClientManager
    @Injectable private var matrixUseCase: MatrixUseCaseProtocol
    private let userSettings: UserCredentialsStorage & UserFlowsStorage
    private let keychainService: KeychainServiceProtocol

    // MARK: - Lifecycle

    init(
        userId: Contact,
        userSettings: UserCredentialsStorage & UserFlowsStorage,
        keychainService: KeychainServiceProtocol
    ) {
        self.userId = userId
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

    func send(_ event: FriendProfileFlow.Event) {
        eventSubject.send(event)
    }

    // MARK: - Private Methods

    private func bindInput() {
        eventSubject
            .sink { [weak self] event in
                switch event {
                case .onProfileAppear:
                    self?.fetchData()
                case .onAppear:
                    print("onAppear")
                case let .onShow(type):
                    switch type {
                    default:
                        ()
                    }
                case .onSocial:
                    print("onSocial")
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
        self.profile.avatar = self.userId.avatar
        profile.name = self.userId.name
        profile.nickname = self.userId.name
        profile.phone = self.userId.phone
        profile.status = self.userId.status
        if !matrixUseCase.getDisplayName().isEmpty {
            profile.name = matrixUseCase.getDisplayName()
        }
        if !matrixUseCase.getStatus().isEmpty {
            profile.status = matrixUseCase.getStatus()
        }
        mediaService.getPhotoFeedPhotos(userId: self.userId.mxId) { urls in
            self.profile.photosUrls = urls
        }
        getSocialList()
        if let phoneNumber = keychainService.apiUserPhoneNumber {
            profile.phone = phoneNumber
        }
    }
}
