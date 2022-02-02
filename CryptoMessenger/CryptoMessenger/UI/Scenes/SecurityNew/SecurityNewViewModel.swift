import SwiftUI
import Combine
import LocalAuthentication

final class SecurityNewViewModel: ObservableObject {

    // MARK: - Internal Properties

    weak var delegate: SecurityNewSceneDelegate?

    @Published private(set) var state: SecurityNewFlow.ViewState = .idle
    @Published var profileObserveState = ""
    @Published var lastSeenState = ""
    @Published var callsState = ""
    @Published var geopositionState = ""
    @Published var telephoneState = ""
    @Published var isPinCodeOn = true
    @Published var isFalsePinCodeOn = true
    @Published var isBiometryOn = true

    // MARK: - Private Properties

    private(set) var localAuth = LocalAuthentication()
    private let eventSubject = PassthroughSubject<SecurityNewFlow.Event, Never>()
    private let stateValueSubject = CurrentValueSubject<SecurityNewFlow.ViewState, Never>(.idle)
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

    func send(_ event: SecurityNewFlow.Event) {
        eventSubject.send(event)
    }

    func updateProfileObserveState(item: String) {
        profileObserveState = item
        userCredentialsStorageService.profileObserveState = item
    }

    func updateLastSeenState(item: String) {
        lastSeenState = item
        userCredentialsStorageService.lastSeenState = item
    }

    func updateCallsState(item: String) {
        callsState = item
        userCredentialsStorageService.callsState = item
    }

    func updateGeopositionState(item: String) {
        geopositionState = item
        userCredentialsStorageService.geopositionState = item
    }

    func updateTelephoneState(item: String) {
        telephoneState = item
        userCredentialsStorageService.telephoneState = item
    }

    func updateIsPinCodeOn(item: Bool) {
        userFlows.isPinCodeOn = item
    }

    func updateIsFalsePinCode(item: Bool) {
        userFlows.isFalsePinCodeOn = item
    }

    func updateIsBiometryOn(item: Bool) {
        userFlows.isBiometryOn = item
    }

    // MARK: - Private Methods

    private func bindInput() {
        eventSubject
            .sink { [weak self] event in
                switch event {
                case .onAppear:
                    self?.updateData()
                    self?.objectWillChange.send()
                case .onBlockList:
                    self?.delegate?.handleNextScene(.blockList)
                case .onCreatePassword:
                    self?.delegate?.handleNextScene(.pinCode(.pinCodeCreate))
                case .onFalsePassword:
                    self?.delegate?.handleNextScene(.pinCode(.fakePinCode))
                case .onSession:
                    self?.delegate?.handleNextScene(.session)
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
        isPinCodeOn = userFlows.isPinCodeOn
        isFalsePinCodeOn = userFlows.isFalsePinCodeOn
        isBiometryOn = userFlows.isBiometryOn
        profileObserveState = userCredentialsStorageService.profileObserveState
        lastSeenState = userCredentialsStorageService.lastSeenState
        callsState = userCredentialsStorageService.callsState
        geopositionState = userCredentialsStorageService.geopositionState
        telephoneState = userCredentialsStorageService.telephoneState
    }
}
