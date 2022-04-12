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
    @Published var selectedImageURL: URL?
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
    @Published var imageViewerOffset: CGSize = .zero
    @Published var bgOpacity: Double = 1
    @Published var imageScale: CGFloat = 1
    @Published var showImageViewer = false
    @Published var imageToSend = UIImage()
    private let eventSubject = PassthroughSubject<ProfileFlow.Event, Never>()
    private let stateValueSubject = CurrentValueSubject<ProfileFlow.ViewState, Never>(.idle)
    private var subscriptions = Set<AnyCancellable>()
    @State private var showImageEdtior = false

    @Injectable private var apiClient: APIClientManager
    @Injectable private var mxStore: MatrixStore
    @Injectable private var userCredentialsStorageService: UserCredentialsStorageService
    @Injectable private var userFlowsStorageService: UserFlowsStorageService

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

    // MARK: - Private Methods

    private func bindInput() {
        eventSubject
            .sink { [weak self] event in
                switch event {
                case .onAppear:
                    self?.fetchData()
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
        $changedImage
            .receive(on: DispatchQueue.main)
            .sink { [weak self] image in
                guard let image = image else { return }
                self?.send(.onAddPhoto(image))
            }
            .store(in: &subscriptions)
        mxStore.$loginState.sink { [weak self] status in
            switch status {
            case .loggedOut:
                self?.userFlowsStorageService.isAuthFlowFinished = false
                self?.userFlowsStorageService.isOnboardingFlowFinished = false
                self?.userFlowsStorageService.isLocalAuth = false
                self?.userCredentialsStorageService.userPinCode = ""
                self?.delegate?.restartFlow()
            default:
                break
            }
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
            .sink { [weak self] completion in
                switch completion {
                case .failure(let error):
                    if let err = error as? APIError, err == .invalidToken {
                        self?.mxStore.logout()
                    }
                default:
                    break
                }
            } receiveValue: { [weak self] response in
                let link = self?.mxStore.getAvatarUrl() ?? ""
                let homeServer = Bundle.main.object(for: .matrixURL).asURL()
                self?.profile.avatar = MXURL(mxContentURI: link)?.contentURL(on: homeServer)
                self?.profile.photosUrls = response.compactMap { $0.original }
                print(self?.profile.photosUrls)
            }
            .store(in: &subscriptions)
    }

    private func getSocialList() {
        apiClient.publisher(Endpoints.Social.getSocial(mxStore.getUserId()))
            .sink { [weak self] completion in
                switch completion {
                case .failure(let error):
                    if let err = error as? APIError, err == .invalidToken {
                        self?.mxStore.logout()
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

    func addPhoto(image: UIImage) {
        guard let data = image.jpeg(.medium) else { return }
        let multipartData = MultipartFileData(
            file: "photo",
            mimeType: "image/png",
            fileData: data
        )
        apiClient.publisher(Endpoints.Media.upload(multipartData, name: mxStore.getUserId()))
            .sink { [weak self] completion in
                switch completion {
                case .failure(let error):
                    if let err = error as? APIError, err == .invalidToken {
                        self?.mxStore.logout()
                    }
                default:
                    break
                }
            } receiveValue: { [weak self] _ in
                self?.getPhotos()
            }
            .store(in: &subscriptions)
    }

    private func fetchData() {
        let link = mxStore.getAvatarUrl()
        let homeServer = Bundle.main.object(for: .matrixURL).asURL()
        profile.avatar = MXURL(mxContentURI: link)?.contentURL(on: homeServer)
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
    }
}

extension ProfileViewModel {
    func onChange(value: CGSize) {
        imageViewerOffset = value
        let halgHeight = UIScreen.main.bounds.height / 2
        let progress = imageViewerOffset.height / halgHeight
//        withAnimation(.default) {
//            bgOpacity = Double(1 - (progress < 0 ? -progress : progress))
//        }
    }

    func onEnd(value: DragGesture.Value) {
        withAnimation(.easeInOut) {
            var transtlation = value.translation.height
            if transtlation < 0 {
                transtlation  = -transtlation
            }
            if transtlation < 250 {
                imageViewerOffset = .zero
                bgOpacity = 1
            } else {
                showImageViewer = false
                imageViewerOffset = .zero
                bgOpacity = 1
            }
        }
    }
    
    func uploadImage(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let imageData = try? Data(contentsOf: url) {
                if let image = UIImage(data: imageData) {
                    DispatchQueue.main.async {
                        self?.imageToSend = image
                        print("smkosd  \(image)")
                    }
                }
            }
        }
    }
}
