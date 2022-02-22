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
    @Injectable private var userCredentialsStorageService: UserCredentialsStorageService
    @Injectable private var userFlowsStorageService: UserFlowsStorageService

    // MARK: - Lifecycle

    init() {
        profile.name = mxStore.getDisplayName()
        profile.status = mxStore.getStatus()
        let url = URL(fileURLWithPath: mxStore.getAvatarUrl())
        profile.avatar = url
        let str = userCredentialsStorageService.userPhoneNumber
        let suffixIndex = str.index(str.startIndex, offsetBy: 3)
        profile.phone = String(str[suffixIndex...])
        bindInput()
        bindOutput()
    }

    deinit {
        subscriptions.forEach { $0.cancel() }
        subscriptions.removeAll()
    }

    // MARK: - Internal Methods

    func send(_ event: ProfileDetailFlow.Event) {
        eventSubject.send(event)
    }

    func addPhoto(image: UIImage) {
        guard let data = image.jpeg(.medium) else { return }
        mxStore.setUserAvatarUrl(data) { [weak self] url in
            guard let url = url else { return }
            self?.profile.avatar = url
        }
    }

    // MARK: - Private Methods

    private func bindInput() {
        eventSubject
            .sink { [weak self] event in
                switch event {
                case .onAppear:
                    ()
                case .onDone:
                    self?.mxStore.setDisplayName(self?.profile.name ?? "") {
                        self?.setStatus(self?.profile.status ?? "")
                    }
                case .onLogout:
                    self?.mxStore.logout()
                case .onAvatar:
                    ()
                }
            }
            .store(in: &subscriptions)

        mxStore.$loginState.sink { [weak self] status in
            switch status {
            case .loggedOut:
                self?.userFlowsStorageService.isAuthFlowFinished = false
                self?.userFlowsStorageService.isOnboardingFlowFinished = false
                self?.userFlowsStorageService.isLocalAuth = false
                self?.userFlowsStorageService.isPinCodeOn = false
                self?.delegate?.restartFlow()
            default:
                break
            }
        }
        .store(in: &subscriptions)

        $selectedImage
            .sink { [weak self] image in
                guard let image = image else { return }
                self?.addPhoto(image: image)
                self?.send(.onAvatar)
            }
            .store(in: &subscriptions)
    }

    private func bindOutput() {
        stateValueSubject
            .assign(to: \.state, on: self)
            .store(in: &subscriptions)
    }

    private func setStatus(_ text: String) {
        apiClient.publisher(Endpoints.Profile.status(text))
            .replaceError(with: [:])
            .sink { [weak self] _ in
                self?.closeScreen.toggle()
            }
            .store(in: &subscriptions)
    }
}
