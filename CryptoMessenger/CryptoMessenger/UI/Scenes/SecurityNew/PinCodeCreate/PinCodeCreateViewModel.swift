import SwiftUI
import Combine

final class PinCodeCreateViewModel: ObservableObject {

    // MARK: - Internal Properties

    weak var delegate: PinCodeCreateSceneDelegate?

    // MARK: - Private Properties

    @Published private(set) var state: PinCodeCreateFlow.ViewState = .idle
    private let eventSubject = PassthroughSubject<PinCodeCreateFlow.Event, Never>()
    private let stateValueSubject = CurrentValueSubject<PinCodeCreateFlow.ViewState, Never>(.idle)
    private var subscriptions = Set<AnyCancellable>()

    @Injectable private(set) var mxStore: MatrixStore
    @Injectable private var userCredentialsStorageService: UserCredentialsStorageService
    @Injectable private var userFlows: UserFlowsStorageService

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

    func send(_ event: PinCodeCreateFlow.Event) {
        eventSubject.send(event)
    }

    func createPassword(item: String) {
        userCredentialsStorageService.userPinCode = item
        userFlows.isPinCodeOn = true
    }

    func createFakePassword(item: String) {
        if userCredentialsStorageService.userPinCode == item {
            return
        }
        userCredentialsStorageService.userFalsePinCode = item
        userFlows.isFalsePinCodeOn = true
    }

    // MARK: - Private Methods

    private func bindInput() {
        eventSubject
            .sink { [weak self] event in
                switch event {
                case .onAppear:
                    self?.updateData()
                    self?.objectWillChange.send()
                }
            }
            .store(in: &subscriptions)

        mxStore.objectWillChange
            .receive(on: DispatchQueue.main)
            .sink { _ in
            }
            .store(in: &subscriptions)
    }

    private func bindOutput() {
        stateValueSubject
            .assign(to: \.state, on: self)
            .store(in: &subscriptions)
    }

    private func updateData() {
    }
}
