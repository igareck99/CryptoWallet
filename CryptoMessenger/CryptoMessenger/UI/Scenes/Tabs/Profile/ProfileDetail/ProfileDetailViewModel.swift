import Combine
import SwiftUI

// MARK: - ProfileDetailViewModel

final class ProfileDetailViewModel: ObservableObject {

    // MARK: - Internal Properties

    weak var delegate: ProfileDetailSceneDelegate?

    @Published var profile = ProfileItem()
    @Published private(set) var closeScreen = false
    @Published private(set) var state: ProfileDetailFlow.ViewState = .idle

    // MARK: - Private Properties

    private let eventSubject = PassthroughSubject<ProfileDetailFlow.Event, Never>()
    private let stateValueSubject = CurrentValueSubject<ProfileDetailFlow.ViewState, Never>(.idle)
    private var subscriptions = Set<AnyCancellable>()

    @Injectable private(set) var mxStore: MatrixStore
    @Injectable private var userCredentialsStorageService: UserCredentialsStorageService

    // MARK: - Lifecycle

    init() {
        profile.name = mxStore.getDisplayName()
        profile.phone = userCredentialsStorageService.userPhoneNumber
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

    // MARK: - Private Methods

    private func bindInput() {
        eventSubject
            .sink { [weak self] event in
                switch event {
                case .onAppear:
                    ()
                case .onDone:
                    self?.mxStore.setDisplayName(self?.profile.name ?? "") {
                        self?.closeScreen.toggle()
                    }
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
