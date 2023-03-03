import SwiftUI
import Combine

final class PinCodeCreateViewModel: ObservableObject {

    // MARK: - Internal Properties

    weak var delegate: PinCodeCreateSceneDelegate?
    @Published var titleState = ""
    @Published var descriptionState = ""
    @Published var repeatState = false
    @Published var enteredPassword: [Int] = []
    @Published var repeatPassword: [Int] = []
    @Published var dotesValues = Array(repeating: 0, count: 5)
    @Published var screenType: PinCodeScreenType
    @Published var errorPassword = false
    @Published var finishScreen = false
    @Published var dotesSpacing: CGFloat = 16

    // MARK: - Private Properties

    @Published private(set) var state: PinCodeCreateFlow.ViewState = .idle
    private let eventSubject = PassthroughSubject<PinCodeCreateFlow.Event, Never>()
    private let stateValueSubject = CurrentValueSubject<PinCodeCreateFlow.ViewState, Never>(.idle)
    private var subscriptions = Set<AnyCancellable>()
	private let userSettings: UserFlowsStorage & UserCredentialsStorage
	private let keychainService: KeychainServiceProtocol

    // MARK: - Lifecycle

    init(
		screenType: PinCodeScreenType,
		userSettings: UserFlowsStorage & UserCredentialsStorage,
		keychainService: KeychainServiceProtocol
	) {
        self.screenType = screenType
		self.userSettings = userSettings
		self.keychainService = keychainService
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
		keychainService.apiUserPinCode = item
		userSettings.isLocalAuth = true
		keychainService.isPinCodeEnabled = true
    }

    func createFalsePassword(item: String) {
        if keychainService.apiUserPinCode == item {
            titleState = ""
            descriptionState = R.string.localizable.pinCodeFalseCannotMatch()
            errorPassword = false
            clearPassword()
            titleState = screenType.result.title
            descriptionState = screenType.result.description
            return
        } else {
			keychainService.apiUserFalsePinCode = item
			userSettings.isFalsePinCodeOn = true
            finishScreen = true
        }
    }

    func keyboardAction(item: KeyboardButtonType) {
        switch item {
        case let .number(value):
            if repeatState == false {
                if enteredPassword.count < 5 {
                    enteredPassword.append(value)
                    guard let index = enteredPassword.lastIndex(of: value) else { return }
                    dotesValues[index] = 1
                }
                if enteredPassword.count == 5 {
                    if screenType == .approvePinCode {
                        let password = enteredPassword
                            .compactMap { $0.description }
                            .joined(separator: "")
                        if keychainService.apiUserPinCode == password {
                            descriptionState = R.string.localizable.pinCodeResetPassword()
                            keychainService.removeObject(forKey: .apiUserPinCode)
                            userSettings.isLocalAuth = false
                            keychainService.isPinCodeEnabled = false
                            finishScreen = true
                        } else {
                            errorPassword = true
                            descriptionState = "Неверный пароль"
                            errorPassword = false
                            clearPassword()
                            descriptionState = ""
                        }
                    } else {
                        descriptionState = R.string.localizable.pinCodeRepeatPassword()
                        vibrate(.heavy)
                        dotesValues = Array(repeating: 0, count: 5)
                        repeatState = true
                    }
                }
            } else {
                if repeatPassword.count < 5 {
                    repeatPassword.append(value)
                    guard let index = repeatPassword.lastIndex(of: value) else { return }
                    dotesValues[index] = 1
                }
                if repeatPassword.count == 5 {
                    if repeatPassword == enteredPassword {
                        descriptionState = R.string.localizable.pinCodeSuccessPassword()
                        let newPassword = enteredPassword
                            .compactMap { $0.description }
                            .joined(separator: "")
                        clearPassword()
                        switch screenType {
                        case .pinCodeCreate:
                            createPassword(item: newPassword)
                            finishScreen = true
                        case .falsePinCode:
                            createFalsePassword(item: newPassword)
                        case .approvePinCode:
                            break
                        }
                    } else {
                        errorPassword = true
                        descriptionState = R.string.localizable.pinCodeNotMatchPassword()
                        errorPassword = false
                        clearPassword()
                        descriptionState = screenType.result.description
                    }
                }
            }
        case .delete:
            if repeatState == false {
                let index = enteredPassword.count - 1
                if enteredPassword.count >= 1 {
                    enteredPassword.removeLast()
                    dotesValues[index] = 0
                }
            } else {
                let index = repeatPassword.count - 1
                if repeatPassword.count >= 1 {
                    repeatPassword.removeLast()
                    dotesValues[index] = 0
                }
            }
        default:
            break
        }
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
    }

    private func bindOutput() {
        stateValueSubject
            .assign(to: \.state, on: self)
            .store(in: &subscriptions)
    }

    private func clearPassword() {
        repeatPassword = []
        enteredPassword = []
        dotesValues = Array(repeating: 0, count: 5)
        repeatState = false
    }

    private func updateData() {
        titleState = screenType.result.title
        descriptionState = screenType.result.description
    }
}
