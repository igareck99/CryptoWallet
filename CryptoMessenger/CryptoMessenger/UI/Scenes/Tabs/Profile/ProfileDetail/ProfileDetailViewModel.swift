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
    @Injectable private var userCredentialsStorageService: UserCredentialsStorageService
    @Injectable private var userFlowsStorageService: UserFlowsStorageService

    // MARK: - Lifecycle

    init() {
        profile.name = mxStore.getDisplayName()
        profile.status = mxStore.getStatus()
        let url = URL(fileURLWithPath: mxStore.getAvatarUrl())
        profile.avatar = url
        print("RJKD   \(url) dsdc" )
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
        selectedImage = image
        guard let imageURL = NSURL(fileURLWithPath: NSTemporaryDirectory())
                .appendingPathComponent("TempImage1.png") else {
            return
        }
        let pngData = image.pngData()
        do {
            try pngData?.write(to: imageURL)
        } catch { }
        selectedImageUrl = imageURL.absoluteString
        print("selectedImageUrl   \(selectedImageUrl)")
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
                        self?.mxStore.setStatus(self?.profile.status ?? "") {
                            self?.closeScreen.toggle()
                        }
                    }
                case .onLogout:
                    self?.mxStore.logout()
                case .onAvatar:
                    guard let image = self?.selectedImageUrl else { return }
                    self?.mxStore.setAvatarUrl(image, completion: {
                        guard let str = self?.mxStore.getAvatarUrl() else { return }
                        print("tiefe   \(type(of: str))")
                        let url = URL(fileURLWithPath: str)
                        self?.profile.avatar = url
                    })
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
    }

    private func bindOutput() {
        stateValueSubject
            .assign(to: \.state, on: self)
            .store(in: &subscriptions)
    }
}
