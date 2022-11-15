import Combine
import Foundation

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
	@Published var isFalsePinCodeOnAvailable = false
    @Published var isBiometryOn = true
    @Published var dataIsUpdated = false

	@Published var showBiometryErrorAlert = false

    private(set) var localAuth = LocalAuthentication()
    private let eventSubject = PassthroughSubject<SecurityNewFlow.Event, Never>()
    private let stateValueSubject = CurrentValueSubject<SecurityNewFlow.ViewState, Never>(.idle)
    private var subscriptions = Set<AnyCancellable>()
    let userSettings: UserFlowsStorage & UserCredentialsStorage
	let keychainService: KeychainServiceProtocol
	private let biometryService: BiometryServiceProtocol

    // MARK: - Lifecycle

    init(
		userSettings: UserFlowsStorage & UserCredentialsStorage,
		keychainService: KeychainServiceProtocol = KeychainService.shared,
		biometryService: BiometryServiceProtocol = BiometryService()
	) {
		self.userSettings = userSettings
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

    // MARK: - Internal Methods

	func pinCodeAvailabilityDidChange(value: Bool) {

		guard keychainService.isPinCodeEnabled != value else { return }

		userSettings.isLocalAuth = value
		keychainService.isPinCodeEnabled = value

		let pinCode = keychainService.apiUserPinCode

		guard
			value, (pinCode == nil || pinCode?.isEmpty == true)
		else {
			send(.onApprovePassword)
			return
		}

		debugPrint("$isPinCodeOn: onCreatePassword")
		send(.onCreatePassword)
	}

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
                    self?.delegate?.handleNextScene(.blockList)
                case .onCreatePassword:
                    self?.delegate?.handleNextScene(.pinCode(.pinCodeCreate))
                case .onFalsePassword:
                    self?.delegate?.handleNextScene(.pinCode(.falsePinCode))
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
		isPinCodeOn = (keychainService.isPinCodeEnabled == true)
        isFalsePinCodeOn = userSettings.isFalsePinCodeOn
        isBiometryOn = userSettings.isBiometryOn
        profileObserveState = userSettings.profileObserveState ?? ""
        lastSeenState = userSettings.lastSeenState ?? ""
        callsState = userSettings.callsState ?? ""
        geopositionState = userSettings.geopositionState ?? ""
        telephoneState = userSettings.telephoneState ?? ""
    }
}
