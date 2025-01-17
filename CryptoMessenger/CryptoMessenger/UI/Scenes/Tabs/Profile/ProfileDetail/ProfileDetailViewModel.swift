import Combine
import SwiftUI

// MARK: - ProfileDetailViewModel

final class ProfileDetailViewModel: ObservableObject {

    // MARK: - Internal Properties

    weak var delegate: ProfileDetailSceneDelegate?

    @Published var profile = ProfileItem()
    @Published var closeScreen = false
    @Published var selectedImage: UIImage?
    @Published var selectedImageUrl: String?
    @Published private(set) var state: ProfileDetailFlow.ViewState = .idle

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
                    self?.delegate?.handleNextScene(.socialList)
                case .onDone:
                    if let image = self?.selectedImage?.fixOrientation(),
                       let data = image.jpeg(.medium) {
                        self?.matrixUseCase.setUserAvatarUrl(data) { url in
                            self?.profile.avatar = url
                        }
                    }

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
                        self?.matrixUseCase.clearCredentials()
                        self?.keychainService.isApiUserAuthenticated = false
                        self?.privateDataCleaner.resetPrivateData()
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
                self?.keychainService.removeObject(forKey: .apiUserPinCode)
                self?.delegate?.restartFlow()
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
