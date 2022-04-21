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
    @Published var isPinCodeOn = false
    @Published var isFalsePinCodeOn = true
    @Published var isBiometryOn = true
    @Published var dataIsUpdated = false

    private(set) var localAuth = LocalAuthentication()
    private let eventSubject = PassthroughSubject<SecurityNewFlow.Event, Never>()
    private let stateValueSubject = CurrentValueSubject<SecurityNewFlow.ViewState, Never>(.idle)
    private var subscriptions = Set<AnyCancellable>()
    let userSettings: UserFlowsStorage & UserCredentialsStorage

    // MARK: - Lifecycle

    init(
		userSettings: UserFlowsStorage & UserCredentialsStorage
	) {
		self.userSettings = userSettings
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
		userSettings.profileObserveState = item
    }

    func updateLastSeenState(item: String) {
        lastSeenState = item
		userSettings.lastSeenState = item
    }

    func updateCallsState(item: String) {
        callsState = item
		userSettings.callsState = item
    }

    func updateGeopositionState(item: String) {
        geopositionState = item
		userSettings.geopositionState = item
    }

    func updateTelephoneState(item: String) {
        telephoneState = item
		userSettings.telephoneState = item
    }

    func updateIsPinCodeOn() {
		userSettings.isLocalAuth = userSettings.isLocalAuth
    }

    func updateIsFalsePinCode(item: Bool) {
		userSettings.isFalsePinCodeOn = item
    }

    func updateIsBiometryOn(item: Bool) {
		userSettings.isBiometryOn = item
    }

    func isPinCodeUpdate() -> Bool {
        userSettings.isLocalAuth == isPinCodeOn
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
                case .onApprovePassword:
                    self?.delegate?.handleNextScene(.pinCode(.approvePinCode))
                }
            }
            .store(in: &subscriptions)
    }

    private func bindOutput() {
        stateValueSubject
            .assign(to: \.state, on: self)
            .store(in: &subscriptions)
    }

    private func updateData() {
        isPinCodeOn = userSettings.isLocalAuth
        isFalsePinCodeOn = userSettings.isFalsePinCodeOn
        isBiometryOn = userSettings.isBiometryOn
        profileObserveState = userSettings.profileObserveState ?? ""
        lastSeenState = userSettings.lastSeenState ?? ""
        callsState = userSettings.callsState ?? ""
        geopositionState = userSettings.geopositionState ?? ""
        telephoneState = userSettings.telephoneState ?? ""
    }
}
