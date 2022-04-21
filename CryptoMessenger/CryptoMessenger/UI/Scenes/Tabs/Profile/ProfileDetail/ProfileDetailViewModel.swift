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

    @Injectable private(set) var mxStore: MatrixStore
    @Injectable private var apiClient: APIClientManager
    private let userSettings: UserFlowsStorage & UserCredentialsStorage

    // MARK: - Lifecycle

    init(
		userSettings: UserFlowsStorage & UserCredentialsStorage
	) {
		self.userSettings = userSettings
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
                    if let image = self?.selectedImage?.fixOrientation(), let data = image.jpeg(.medium) {
                        self?.mxStore.setUserAvatarUrl(data) { url in
                            self?.profile.avatar = url
                        }
                    }

                    if let name = self?.profile.name {
                        self?.mxStore.setDisplayName(name) {}
                    }

                    if let status = self?.profile.status {
                        self?.mxStore.setStatus(status) {}
                    }

                    delay(0.5) {
                        self?.closeScreen.toggle()
                    }
                case .onLogout:
                    self?.mxStore.logout()
                }
            }
            .store(in: &subscriptions)

        mxStore.$loginState.sink { [weak self] status in
            switch status {
            case .loggedOut:
                self?.userSettings.isAuthFlowFinished = false
                self?.userSettings.isOnboardingFlowFinished = false
                self?.userSettings.isLocalAuth = false
                self?.userSettings.userPinCode = ""
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
        profile.name = mxStore.getDisplayName()
        profile.status = mxStore.getStatus()
        let link = mxStore.getAvatarUrl()
        let homeServer = Bundle.main.object(for: .matrixURL).asURL()
        profile.avatar = MXURL(mxContentURI: link)?.contentURL(on: homeServer)
		if let str = userSettings.userPhoneNumber {
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
