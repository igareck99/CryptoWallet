import Combine
import Foundation

protocol SecurityViewModelProtocol: ObservableObject {
    
}

final class SecurityViewModel: SecurityViewModelProtocol {

    // MARK: - Internal Properties

    var coordinator: ProfileCoordinatable?

    @Published private(set) var state: SecurityFlow.ViewState = .idle
    @Published var profileObserveState = ""
    @Published var lastSeenState = ""
    @Published var callsState = ""
    @Published var geopositionState = ""
    @Published var telephoneState = ""
    @Published var isPinCodeOn = false
    @Published var isFalsePinCodeOn = true
	@Published var isFalsePinCodeOnAvailable = false
    @Published var isBiometryOn = true
    @Published var dataIsUpdated = false
	@Published var showBiometryErrorAlert = false
    @Published var isPrivacyAvailable = false
    var togglesFacade: MainFlowTogglesFacadeProtocol
    let userSettings: UserFlowsStorage & UserCredentialsStorage
    let keychainService: KeychainServiceProtocol
    let resources: SecurityResourcable.Type

    // MARK: - Private Properties

    private(set) var localAuth = LocalAuthentication()
    private let eventSubject = PassthroughSubject<SecurityFlow.Event, Never>()
    private let stateValueSubject = CurrentValueSubject<SecurityFlow.ViewState, Never>(.idle)
    private var subscriptions = Set<AnyCancellable>()
	private let biometryService: BiometryServiceProtocol

    // MARK: - Lifecycle

    init(
        userSettings: UserFlowsStorage & UserCredentialsStorage,
        togglesFacade: MainFlowTogglesFacadeProtocol,
        keychainService: KeychainServiceProtocol = KeychainService.shared,
        biometryService: BiometryServiceProtocol = BiometryService(),
        resources: SecurityResourcable.Type = SecurityResources.self
    ) {
        self.resources = resources 
        self.userSettings = userSettings
        self.togglesFacade = togglesFacade
		self.keychainService = keychainService
		self.biometryService = biometryService
        bindInput()
        bindOutput()
    }

    deinit {
        subscriptions.forEach { $0.cancel() }
        subscriptions.removeAll()
    }

	func authenticate() {
        if biometryService.checkIfBioMetricAvailable() {
            biometryService.authenticateByBiometry(
                reason: localAuth.biometryEnableReasonText()
            ) { [weak self] result in
                DispatchQueue.main.async {
                    switch result {
                    case .suceeded:
                        self?.isBiometryOn = true
                        self?.updateIsBiometryOn(item: true)
                        return
                    case .failedByEvaluation:
                        self?.isBiometryOn = false
                        self?.updateIsBiometryOn(item: false)
                        self?.showBiometryErrorAlert = true
                        return
                    case .failedByBiometry:
                        self?.isBiometryOn = false
                        self?.updateIsBiometryOn(item: false)
                        return
                    }
                }
            }
        }
	}

    // MARK: - Internal Methods

	func pinCodeAvailabilityDidChange(value: Bool) {

		guard keychainService.isPinCodeEnabled != value else { return }

		let pinCode = keychainService.apiUserPinCode

        if value {
            send(.onCreatePassword)
        } else {
            send(.onRemovePassword)
        }
	}

    func isPhraseExist() -> Bool {
        guard let phrase = keychainService.secretPhrase else { return false }
        if phrase.isEmpty {
            return false
        }
        return true
    }

    func send(_ event: SecurityFlow.Event) {
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

    func updateIsFalsePinCode(item: Bool) {
		userSettings.isFalsePinCodeOn = item
    }

    func updateIsBiometryOn(item: Bool) {
		userSettings.isBiometryOn = item
    }

    func isPinCodeUpdate() -> Bool {
		keychainService.isPinCodeEnabled == isPinCodeOn
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
                    self?.coordinator?.blockList()
                case .onCreatePassword:
                    self?.coordinator?.pinCode(pinCodeScreen: .pinCodeCreate)
                case .onFalsePassword:
                    self?.coordinator?.pinCode(pinCodeScreen: .falsePinCode)
                case .onSession:
                    self?.coordinator?.sessions()
                case .onApprovePassword:
                    self?.coordinator?.pinCode(pinCodeScreen: .approvePinCode)
                case .onImportKey:
                    self?.showPhraseView()
                case .onPhrase:
                    self?.showPhraseView()
                case .onRemovePassword:
                    self?.coordinator?.pinCode(pinCodeScreen: .pinCodeRemove)
                case .biometryActivate:
                    guard let value = self?.biometryService.checkIfBioMetricAvailable() else { return }
                    if value {
                        self?.coordinator?.pinCode(pinCodeScreen: .biometry)
                    } else {
                        self?.isBiometryOn = false
                    }
                }
            }
            .store(in: &subscriptions)
    }

    private func showPhraseView() {
        if let phrase = keychainService.secretPhrase {
            coordinator?.showPhrase(seed: phrase)
            return
        }

        coordinator?.generatePhrase()
    }

    private func bindOutput() {
        stateValueSubject
            .assign(to: \.state, on: self)
            .store(in: &subscriptions)
    }

    private func updateData() {
		isPinCodeOn = (keychainService.isPinCodeEnabled == true)
        isFalsePinCodeOn = userSettings.isFalsePinCodeOn
        isPrivacyAvailable = togglesFacade.isPrivacyAvailable
        isBiometryOn = userSettings.isBiometryOn
        profileObserveState = userSettings.profileObserveState ?? ""
        lastSeenState = userSettings.lastSeenState ?? ""
        callsState = userSettings.callsState ?? ""
        geopositionState = userSettings.geopositionState ?? ""
        telephoneState = userSettings.telephoneState ?? ""
    }
}
