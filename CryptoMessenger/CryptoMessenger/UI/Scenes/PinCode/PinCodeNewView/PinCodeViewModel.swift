import Combine
import SwiftUI

// MARK: - PinCodeViewModelDelegate

protocol PinCodeViewModelDelegate: ObservableObject {

    var errorPassword: Bool { get }

    var title: String { get }

    var sources: PinCodeSourcesable.Type { get }
    
    var animation: CGFloat { get set }

    var showRemoveSheet: Bool { get set }

    var colors: [Color] { get set }

    var disappearScreen: Bool { get }

    var gridItem: [KeyboardButtonType] { get }

    var auraLogo: Image { get }

    var dotesValues: [Int] { get }

    func keyboardAction(item: KeyboardButtonType)

    func send(_ event: PinCodeFlow.Event)

    func removePassword()

    func setToStart()
}

// MARK: - PinCodeViewModel

final class PinCodeViewModel: ObservableObject, PinCodeViewModelDelegate {

    var delegate: PinCodeSceneDelegate?
    var screenType: PinCodeScreenType
    let firstStack: [KeyboardButtonType] = [.number(1),
                                            .number(2),
                                            .number(3)
    ]
    let secondStack: [KeyboardButtonType] = [.number(4),
                                            .number(5),
                                            .number(6)
    ]
    let thirdStack: [KeyboardButtonType] = [.number(7),
                                            .number(8),
                                            .number(9)
    ]
    let fourthStack: [KeyboardButtonType] = [.empty,
                                            .number(0),
                                            .delete
    ]
    var gridItem: [KeyboardButtonType] = [.number(1),
                                          .number(2),
                                          .number(3),
                                          .number(4),
                                          .number(5),
                                          .number(6),
                                          .number(7),
                                          .number(8),
                                          .number(9),
                                          .empty,
                                          .number(0),
                                          .delete]
    @Published var enteredPassword: [Int] = []
    @Published var repeatState = false
    @Published var firstPassword: [Int] = []
    @Published var auraLogo = Image("")
    @Published var title = ""
    @Published var disappearScreen = false
    @Published var dotesValues = Array(repeating: 0, count: 5)
    @Published var errorPassword = false
    @Published var animation: CGFloat = 0

    // MARK: - Private Properties

    private(set) var localAuth = LocalAuthentication()
    @Published private(set) var state: PinCodeFlow.ViewState = .idle
    private let eventSubject = PassthroughSubject<PinCodeFlow.Event, Never>()
    private let stateValueSubject = CurrentValueSubject<PinCodeFlow.ViewState, Never>(.idle)
    private var subscriptions = Set<AnyCancellable>()
    private let userSettings: UserFlowsStorage & UserCredentialsStorage
    private let keychainService: KeychainServiceProtocol
    private let biometryService: BiometryServiceProtocol
    let sources: PinCodeSourcesable.Type
    
    @Published var colors: [Color] = []
    @Published var showRemoveSheet = false

    // MARK: - Lifecycle

    init(delegate: PinCodeSceneDelegate?,
         screenType: PinCodeScreenType,
         userSettings: UserFlowsStorage & UserCredentialsStorage,
         keychainService: KeychainServiceProtocol,
         biometryService: BiometryServiceProtocol,
         sources: PinCodeSourcesable.Type) {
        self.delegate = delegate
        self.screenType = screenType
        self.userSettings = userSettings
        self.keychainService = keychainService
        self.biometryService = biometryService
        self.sources = sources
        bindInput()
        bindOutput()
    }

    // MARK: - Internal Methods

    func send(_ event: PinCodeFlow.Event) {
        eventSubject.send(event)
    }
    
    func setToStart() {
        self.enteredPassword = []
        self.dotesValues = Array(repeating: 0, count: 5)
    }
    
    func computeDotes() {
        switch errorPassword {
        case false:
            self.colors = []
            for i in dotesValues {
                colors.append(i == 0 ? .antiFlashWhite : .azureRadianceApprox)
            }
        case true:
            self.colors = []
            for _ in dotesValues {
                colors.append(.spanishCrimson)
            }
            animation = 5
        }
    }

    func keyboardAction(item: KeyboardButtonType) {
        switch item {
        case let .number(value):
            guard enteredPassword.count < 5 else { return }
            enteredPassword.append(value)
            guard let index = enteredPassword.lastIndex(of: value) else { return }
            dotesValues[index] = 1
        case .delete:
            let index = enteredPassword.count - 1
            guard enteredPassword.count >= 1 else { return }
            enteredPassword.popLast()
            dotesValues[index] = 0
        case .faceId, .touchId:
            self.authenticate { result in
                if result == .suceeded {
                    self.delegate?.handleNextScene()
                }
            }
        default:
            break
        }
        self.objectWillChange.send()
    }

    // MARK: - Private Methods

    private func bindInput() {
        eventSubject
            .sink { [weak self] event in
                switch event {
                case .onAppear:
                    guard let self = self else { return }
                    self.updateView()
                    self.objectWillChange.send()
                }
            }
            .store(in: &subscriptions)
        $enteredPassword
            .receive(on: DispatchQueue.main)
            .sink { [weak self] value in
                guard let self = self else { return }
                self.computeDotes()
                self.objectWillChange.send()
                guard value.count == 5 else { return }
                switch screenType {
                case .login:
                    self.login()
                case .pinCodeCreate:
                    guard !repeatState else {
                        self.createPassword()
                        return
                    }
                    self.repeatState.toggle()
                    self.title = self.sources.repeatPassword
                    self.firstPassword = self.enteredPassword
                    self.setToStart()
                case .pinCodeRemove:
                    let password = enteredPassword.map({ String($0) })
                        .joined(separator: "")
                    if self.keychainService.apiUserPinCode == password {
                        self.showRemoveSheet = true
                    } else {
                        self.errorDisplay()
                    }
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

    private func login() {
        let pinCode = keychainService.apiUserPinCode
        let password = enteredPassword.map({ String($0) })
                                      .joined(separator: "")
        if pinCode == password {
            self.delegate?.handleNextScene()
        } else {
            errorDisplay()
        }
    }

    func removePassword() {
        let password = enteredPassword.map({ String($0) })
                                      .joined(separator: "")
        keychainService.apiUserPinCode = ""
        keychainService.isPinCodeEnabled = false
        userSettings.isBiometryOn = false
        disappearScreen = true
    }

    private func createPassword() {
        guard self.enteredPassword == self.firstPassword else {
            errorDisplay()
            return
        }
        let password = enteredPassword.map({ String($0) })
            .joined(separator: "")
        keychainService.apiUserPinCode = password
        keychainService.isPinCodeEnabled = true
        self.title = sources.passwordHasBeenSet
        delay(0.5) {
            self.disappearScreen = true
        }
    }

    private func updateView() {
        self.auraLogo = sources.auraLogo
        self.title = sources.enterPassword
        if (userSettings.isBiometryOn && screenType == .login) || screenType == .biometry {
            switch self.localAuth.getAvailableBiometrics() {
            case .faceID:
                gridItem[9] = .faceId
                authOnAppear()
            case .touchID:
                gridItem[9] = .touchId
                authOnAppear()
            case .none:
                break
            }
        }
    }

    private func authOnAppear() {
        authenticate { result in
            switch result {
            case .failedByEvaluation:
                ()
            case .failedByBiometry:
                if self.screenType == .biometry {
                    self.disappearScreen = true
                }
            case .suceeded:
                if self.screenType == .biometry {
                    self.userSettings.isBiometryOn = true
                    self.disappearScreen = true
                    return
                }
                self.delegate?.handleNextScene()
            }
        }
    }

    private func errorDisplay() {
        errorPassword = true
        self.computeDotes()
        auraLogo = sources.auraLogoRed
        delay(0.5) {
            self.title = self.sources.enterPassword
            self.errorPassword = false
            self.repeatState = false
            self.auraLogo = self.sources.auraLogo
            self.setToStart()
        }
    }

    private func authenticate(completion: @escaping (BiometryResult) -> Void) {
        biometryService.authenticateByBiometry(
            reason: localAuth.biometryEnableReasonText()
        ) { [weak self] result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
    }
}
