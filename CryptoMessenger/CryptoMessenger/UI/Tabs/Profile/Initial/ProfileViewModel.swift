import Combine
import SwiftUI

protocol ProfileViewModelProtocol: ObservableObject {
    var isEmptyFeed: Bool { get set }
    var showWebView: Bool { get set }
    var isSnackbarPresented: Bool { get set }
    var messageText: String { get set }
    var selectedImage: UIImage? { get set }
    var safari: SFSafariViewWrapper? { get set }
    var selectedPhoto: URL? { get set }
    var existringUrls: [String] { get set }
    var imageToShare: UIImage? { get set }
    var socialListEmpty: Bool { get set }
    var profile: ProfileItem { get set }
    var fullNumber: String { get set }
    var resources: ProfileResourcable.Type { get }

    func deleteImageByUrl(completion: @escaping () -> Void)
    func shareImage(completion: @escaping () -> Void)
    func send(_ event: ProfileFlow.Event)
    func onUserIdCopyTap()
    func onSafari(_ url: String)
}

final class ProfileViewModel: ProfileViewModelProtocol {

    // MARK: - Internal Properties

    var coordinator: ProfileCoordinatable?
    @Published var isSnackbarPresented = false
    @Published var fullNumber: String = ""
    @Published var messageText: String = ""
    @Published var selectedImage: UIImage?
    @Published var selectedVideo: URL?
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
    @Published var isVoiceCallAvailablility = false
    @Published var menuHeight: CGFloat = 0
    @Published var deleteImage = false
    @Published var isEmptyFeed = true
    @Published var urlToOpen: URL?
    @Published var showWebView = false
    var safari: SFSafariViewWrapper?

    // MARK: - Private Properties

    @Published private(set) var state: ProfileFlow.ViewState = .idle
    @Published private(set) var socialList = SocialListViewModel()
    @Published var socialListEmpty = true
    private let eventSubject = PassthroughSubject<ProfileFlow.Event, Never>()
    private let stateValueSubject = CurrentValueSubject<ProfileFlow.ViewState, Never>(.idle)
    private var subscriptions = Set<AnyCancellable>()
    let mediaService = MediaService()
    @State private var showImageEdtior = false

    @Injectable private var apiClient: APIClientManager
    @Injectable private var matrixUseCase: MatrixUseCaseProtocol
    private let userSettings: UserCredentialsStorage & UserFlowsStorage
    private let keychainService: KeychainServiceProtocol
    private let pasteboardService: PasteboardServiceProtocol
    let resources: ProfileResourcable.Type

    // MARK: - Lifecycle

    init(
        coordinator: ProfileCoordinatable? = nil,
        userSettings: UserCredentialsStorage & UserFlowsStorage,
        keychainService: KeychainServiceProtocol,
        resources: ProfileResourcable.Type = ProfileResources.self,
        pasteboardService: PasteboardServiceProtocol = PasteboardService()
    ) {
        self.coordinator = coordinator
        self.userSettings = userSettings
        self.keychainService = keychainService
        self.resources = resources
        self.pasteboardService = pasteboardService
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
        self.isEmptyFeed = self.profile.photosUrls.isEmpty
        self.objectWillChange.send()
    }

    func onSafari(_ url: String) {
        guard let url = URL(string: url) else { return }
        urlToOpen = url
        self.safari = SFSafariViewWrapper(link: url)
        showWebView = true
    }

    func onUserIdCopyTap() {
        pasteboardService.copyToPasteboard(text: profile.nickname)
    }

    // MARK: - Private Methods

    private func bindInput() {
        eventSubject
            .sink { [weak self] event in
                switch event {
                case .onProfileAppear:
                    self?.fetchData()
                    self?.updateCallState()
                case .onAppear:
                    self?.fetchImageData()
                case .onSocial:
                    self?.coordinator?.onSocialList()
                case .onFeedImageAdd:
                    guard let self = self else { return }
                    self.coordinator?.showFeedPicker { [weak self] value in
                        self?.coordinator?.galleryPickerFullScreen(
                            sourceType: value,
                            galleryContent: .all,
                            onSelectImage: { [weak self] image in
                                guard let image = image else {
                                    self?.showSnackBar(text: "Не удалось выбрать картинку")
                                    return
                                }
                                self?.selectedImage = image
                            },
                            onSelectVideo: { _ in }
                        )
                    }
                case let .onSettings(image):
                    guard let self = self, let coordinator = coordinator else { return }
                    coordinator.showSettings { [weak self] result in
                        self?.coordinator?.settingsScreens(
                            type: result,
                            cooordinator: coordinator,
                            image: image
                        )
                    }
                case let .onGallery(type):
                    guard let self = self else { return }
                    self.coordinator?.galleryPickerFullScreen(
                        sourceType: type,
                        galleryContent: .all,
                        onSelectImage: { [weak self] image in
                            guard let image = image else {
                                self?.showSnackBar(text: "Не удалось выбрать картинку")
                                return
                            }
                            self?.selectedImage = image
                        },
                        onSelectVideo: { _ in }
                    )
                case let .onImageEditor(
                    isShowing: isShowing,
                    image: image
                ):
                // TODO: ?????
//                    self?.coordinator?.imageEditor(
//                        isShowing: isShowing,
//                        image: image,
//                        viewModel: self
//                    )
                    guard let image = image.wrappedValue else { 
                        self?.showSnackBar(text: "Не удалось загрузить фото в ленту")
                        return
                    }
                    self?.eventSubject.send(.onAddPhoto(image))
                case let .onAddPhoto(image):
                    guard let userId = self?.matrixUseCase.getUserId() else {
                        self?.showSnackBar(text: "Не удалось получить идентификатор пользователя")
                        return
                    }
                    self?.mediaService.addPhotoFeed(
                        image: image,
                        userId: userId
                    ) { [weak self] url in
                        guard let realUrl = url else {
                            self?.showSnackBar(text: "Не удалось добавить фото")
                            return
                        }
                        self?.profile.photosUrls.insert(realUrl, at: 0)
                        self?.fetchData()
                        self?.objectWillChange.send()
                    }
                }
            }
            .store(in: &subscriptions)

        $changedImage
            .receive(on: DispatchQueue.main)
            .sink { [weak self] image in
                guard let image = image else {return}
                self?.send(.onAddPhoto(image))
                self?.objectWillChange.send()
            }
            .store(in: &subscriptions)

        $selectedPhoto
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in }
            .store(in: &subscriptions)

        matrixUseCase.loginStatePublisher.sink { [weak self] status in
            switch status {
            case .loggedOut:
                self?.userSettings.isAuthFlowFinished = false
                self?.userSettings.isOnboardingFlowFinished = false
                self?.keychainService.removeObject(forKey: .apiUserPinCode)
                // self?.coordinator?.restartFlow()
            case .failure(_):
                self?.showSnackBar(text: "Не удалось разлогиниться")
            default: break
            }
        }
        .store(in: &subscriptions)

        matrixUseCase.objectChangePublisher
            .subscribe(on: DispatchQueue.global(qos: .userInteractive))
            .receive(on: DispatchQueue.main)
            .sink { _ in }
            .store(in: &subscriptions)
    }

    func showSnackBar(text: String) {
        delay(0.5) { [weak self] in
            self?.messageText = text
            self?.isSnackbarPresented = true
            self?.objectWillChange.send()
        }

        delay(3) { [weak self] in
            self?.messageText = ""
            self?.isSnackbarPresented = false
            self?.objectWillChange.send()
        }
    }

    func deleteImageByUrl(completion: @escaping () -> Void) {
        guard let url = self.selectedPhoto else {
            return
        }
        self.mediaService.deletePhotoFeed(url: url.absoluteString) { _ in
            self.mediaService.getPhotoFeedPhotos(userId: self.matrixUseCase.getUserId()) { urls in
                self.profile.photosUrls = urls
                self.isEmptyFeed = self.profile.photosUrls.isEmpty
                completion()
            }
        }
    }

    func shareImage(completion: @escaping () -> Void) {
        DispatchQueue.global().async { [weak self] in
            guard let uploadUrl = self?.selectedPhoto else { return }
            if let imageData = try? Data(contentsOf: uploadUrl) {
                if let image = UIImage(data: imageData) {
                    DispatchQueue.main.async {
                        self?.imageToShare = image
                        completion()
                    }
                }
            }
        }
    }

    private func bindOutput() {
        stateValueSubject
            .assign(to: \.state, on: self)
            .store(in: &subscriptions)
    }

    private func getSocialList() {
        guard let userId = userSettings.userId,
            !userId.isEmpty
        else {
            return
        }

        apiClient.publisher(Endpoints.Social.getSocial(
//            matrixUseCase.getUserId()
            userId
        ))
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

    private func updateCallState() {
        let isCallInProgress = userSettings.bool(forKey: .isCallInprogressExists)
        self.isVoiceCallAvailablility = isCallInProgress
        if isCallInProgress {
            menuHeight = UIScreen.main.bounds.height - 120
        } else {
            menuHeight = UIScreen.main.bounds.height - 90
        }
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
        } else {
            profile.status = ""
        }
        mediaService.getPhotoFeedPhotos(userId: matrixUseCase.getUserId()) { urls in
            self.profile.photosUrls = urls
            self.isEmptyFeed = self.profile.photosUrls.isEmpty
        }
        getSocialList()
        if var phoneNumber = keychainService.apiUserPhoneNumber {
            if phoneNumber.firstLetter != "+"{
                phoneNumber = "+" + phoneNumber
            }
            profile.dialCode = PhoneHelper.getDialCode(forPhoneNumber:phoneNumber) ?? ""
            profile.phone =  PhoneHelper.formatToInternationalNumber(phoneNumber, forRegion: PhoneHelper.userRegionCode) ?? ""
            fullNumber = profile.dialCode + " " + profile.phone
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
        self.objectWillChange.send()
    }
}
