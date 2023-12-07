import Combine
import SwiftUI

// MARK: - ProfileDetailViewModel

final class ProfileDetailViewModel: ObservableObject {

    // MARK: - Internal Properties

    var coordinator: ProfileCoordinatable?

    @Published var profile = ProfileItem()
    @Published var closeScreen = false
    @Published private(set) var state: ProfileDetailFlow.ViewState = .idle

    @Published var selectedImg: UIImage? {
        didSet {
            self.objectWillChange.send()
        }
    }

    var selectedVid: URL? {
        didSet {
            self.objectWillChange.send()
        }
    }

    // MARK: - Private Properties

    private let eventSubject = PassthroughSubject<ProfileDetailFlow.Event, Never>()
    private let stateValueSubject = CurrentValueSubject<ProfileDetailFlow.ViewState, Never>(.idle)
    private var subscriptions = Set<AnyCancellable>()

    @Injectable private(set) var matrixUseCase: MatrixUseCaseProtocol
    @Injectable private var apiClient: APIClientManager
    private let userSettings: UserFlowsStorage & UserCredentialsStorage
    private let keychainService: KeychainServiceProtocol
    private let privateDataCleaner: PrivateDataCleanerProtocol
    private let config: ConfigType

    // MARK: - Lifecycle

    init(
        userSettings: UserFlowsStorage & UserCredentialsStorage,
        keychainService: KeychainServiceProtocol,
        coreDataService: CoreDataServiceProtocol,
        privateDataCleaner: PrivateDataCleanerProtocol,
        config: ConfigType = Configuration.shared
    ) {
        self.userSettings = userSettings
        self.keychainService = keychainService
        self.privateDataCleaner = privateDataCleaner
        self.config = config
        bindInput()
        bindOutput()
        fetchData()
    }

    deinit {
        subscriptions.forEach { $0.cancel() }
        subscriptions.removeAll()
    }

    // MARK: - Internal Methods

    func send(_ event: ProfileDetailFlow.Event) {
        eventSubject.send(event)
    }

    // MARK: - Private Methods

    private func bindInput() {
        eventSubject
            .sink { [weak self] event in
                switch event {
                case .onAppear:
                    ()
                case .onSocial:
                    self?.coordinator?.onSocialList()
                case let .onGallery(type):
                    guard let self = self else { return }
                    self.coordinator?.galleryPickerFullScreen(sourceType: type,
                                                              galleryContent: .all, onSelectImage: { image in
                        if let image = image {
                            self.selectedImg = image
                            self.updateAvatar()
                        }
                    }, onSelectVideo: { _ in
                    })
                case .onDone:
                    if let name = self?.profile.name {
                        self?.matrixUseCase.setDisplayName(name) {}
                    }

                    if let status = self?.profile.status {
                        self?.matrixUseCase.setStatus(status) {}
                    }

                    delay(0.5) {
                        self?.closeScreen.toggle()
                    }
                case .onLogout:
                    self?.matrixUseCase.logoutDevices { [weak self] _ in
                        // TODO: Обработать результат
                        self?.matrixUseCase.closeSession()
                        self?.privateDataCleaner.resetPrivateData()
                        self?.matrixUseCase.clearCredentials()
                        self?.keychainService.isApiUserAuthenticated = false
                        self?.keychainService.isPinCodeEnabled = false
                        NotificationCenter.default.post(name: .userDidLoggedOut, object: nil)
                        debugPrint("ProfileDetailViewModel: LOGOUT")
                    }
                }
            }
            .store(in: &subscriptions)

        matrixUseCase.loginStatePublisher.sink { [weak self] status in
            switch status {
            case .loggedOut:
                self?.userSettings.isAuthFlowFinished = false
                self?.userSettings.isOnboardingFlowFinished = false
                self?.keychainService.isPinCodeEnabled = false
                self?.keychainService.removeObject(forKey: .apiUserPinCode)
                self?.privateDataCleaner.resetPrivateData()
                self?.matrixUseCase.clearCredentials()
                DispatchQueue.main.async {
                    self?.coordinator?.onLogout()
                }
            default:
                break
            }
        }
        .store(in: &subscriptions)
    }

    private func bindOutput() {
        stateValueSubject
            .assign(to: \.state, on: self)
            .store(in: &subscriptions)
    }

    private func updateAvatar() {
        if let image = self.selectedImg?.fixOrientation(),
           let data = image.jpeg(.medium) {
            self.matrixUseCase.setUserAvatarUrl(data) { url in
                self.profile.avatar = url
            }
        }
    }

    private func fetchData() {
        profile.name = matrixUseCase.getDisplayName()
        profile.status = matrixUseCase.getStatus()
        matrixUseCase.getAvatarUrl { [weak self] link in
            guard let self = self else { return }
            let link = link
            let homeServer = self.config.matrixURL
            self.profile.avatar = MXURL(mxContentURI: link)?.contentURL(on: homeServer)
            self.objectWillChange.send()
        }
        if let str = keychainService.apiUserPhoneNumber {
            let suffixIndex = str.index(str.startIndex, offsetBy: 3)
            profile.phone = String(str[suffixIndex...])
        }
    }

    private func setStatus(_ text: String) {
        apiClient.publisher(Endpoints.Profile.status(text))
            .replaceError(with: [:])
            .sink { _ in }
            .store(in: &subscriptions)
    }
}
