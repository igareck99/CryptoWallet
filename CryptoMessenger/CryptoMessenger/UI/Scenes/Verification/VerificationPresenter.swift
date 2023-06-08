import Combine
import Foundation
import SwiftUI

// swiftlint:disable all

protocol VerificationPresenterProtocol: ObservableObject {
    
    associatedtype Colors: VerificationColorable
    var colors: Colors { get }

    var seconds: Int { get }
    var phoneNumber: String { get }
    var numberOfInputs: Int { get }
    var errorTextOpacity: Binding<Double> { get }
    var verificationCode: Binding<String> { get set }
    var resources: CodeVerificationResourcable.Type { get }
    
    func onTapResend()
    func limitText()
    func hyphenOpacity(_ index: Int) -> Double
    func getPin(_ index: Int) -> String
    func strokeColor(_ index: Int) -> Color
}

final class VerificationPresenter<Colors: VerificationColorable> {
    
    enum VerifiacationState: Int {
        case inputOTP
        case wrongOTP
        case sendOTP
        case resendPhone
        case sendPhoneError
        case failure
    }
    
    let numberOfInputs: Int = 5
    var errorTextOpacity: Binding<Double> = .constant(.zero)
    
    var otpCode = ""
    lazy var verificationCode: Binding<String> = .init(
        get: { self.otpCode },
        set: {
            self.otpCode = $0
            self.otpCode = String(self.otpCode.prefix(self.numberOfInputs))
            self.objectWillChange.send()
        }
    )
    
    var phoneNumber: String {
        keychainService.apiUserPhoneNumber ?? ""
    }
    
    private var verificationState: VerifiacationState = .inputOTP {
        didSet {
            updateOpacity()
            guard verificationState != .inputOTP else { return }
            self.objectWillChange.send()
        }
    }
    
    let resources: CodeVerificationResourcable.Type
    let colors: Colors
    
    private weak var delegate: VerificationSceneDelegate?
    private var apiClient: APIClientManager
    private var configuration: ConfigType
    private let matrixUseCase: MatrixUseCaseProtocol
    private var subscriptions = Set<AnyCancellable>()
    private let keychainService: KeychainServiceProtocol
    private let userSettings: UserCredentialsStorage & UserFlowsStorage
    private let secondsConstant: Int = 30
    private var timer: Timer?
    var seconds: Int = 30
    
    init(
        apiClient: APIClientManager = APIClient.shared,
        configuration: ConfigType = Configuration.shared,
        keychainService: KeychainServiceProtocol = KeychainService.shared,
        userSettings: UserCredentialsStorage & UserFlowsStorage = UserDefaultsService.shared,
        matrixUseCase: MatrixUseCaseProtocol = MatrixUseCase.shared,
        resources: CodeVerificationResourcable.Type = CodeVerificationResources.self,
        colors: Colors = VerificationColors(),
        delegate: VerificationSceneDelegate? = nil
    ) {
        self.apiClient = apiClient
        self.configuration = configuration
        self.keychainService = keychainService
        self.matrixUseCase = matrixUseCase
        self.resources = resources
        self.colors = colors
        self.userSettings = userSettings
        self.delegate = delegate
        startTimer()
    }
    
    deinit {
        stopTimer()
    }
}
    
// MARK: - Private Methods

private extension VerificationPresenter {
    
    func startTimer() {
        seconds = secondsConstant
        timer = Timer.scheduledTimer(
            withTimeInterval: 1,
            repeats: true
        ) { [weak self] _ in
            self?.refresh()
        }
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    func refresh() {
        guard seconds > 0 else { stopTimer(); return }
        seconds -= 1
        self.objectWillChange.send()
    }
    
    func updateOpacity() {
        let value: Double = verificationState == .wrongOTP ? 1 : 0
        errorTextOpacity = .constant(value)
    }
    
    func resetOtpInput() {
        otpCode = ""
        verificationCode.wrappedValue = ""
        self.objectWillChange.send()
    }

    func resendPhone() {
        apiClient
            .publisher(Endpoints.Registration.sms(keychainService.apiUserPhoneNumber?.numbers ?? ""))
            .receive(on: RunLoop.main)
            .sink { [weak self] completion in
                switch completion {
                    case .failure(let error):
                        guard let err = error as? APIError else {
                            self?.verificationState = .sendPhoneError
                            return
                        }
                        self?.verificationState = .sendPhoneError
                    default:
                        break
                }
            } receiveValue: { [weak self] _ in
                self?.verificationState = .inputOTP
                self?.startTimer()
            }
            .store(in: &subscriptions)
    }

    func logIn(_ code: String) {
        
        let endpoint = Endpoints.Registration.auth(
            .init(
                device: .init(name: configuration.deviceName, unique: configuration.deviceId),
                phone: keychainService.apiUserPhoneNumber?.numbers ?? "",
                sms: code
            )
        )

        verificationState = .sendOTP
        apiClient
            .publisher(endpoint)
            .receive(on: RunLoop.main)
            .sink { [weak self] completion in
                switch completion {
                    case .failure(let error):
                        guard let err = error as? APIError else {
                            self?.verificationState = .wrongOTP
                            return
                        }
                        self?.verificationState = .wrongOTP
                    default:
                        break
                }
            } receiveValue: { [weak self] response in
                
                // TODO: Обработать отсутсвие userId
                guard let userId = response.userId,
                      let password = response.matrixPassword,
                      let homeServer = self?.configuration.matrixURL else {
                    self?.verificationState = .wrongOTP
                    return
                }
                
                self?.loginMatrix(
                    userId: userId,
                    password: password,
                    homeServer: homeServer,
                    accessToken: response.accessToken,
                    refreshToken: response.refreshToken
                )
            }
            .store(in: &subscriptions)
    }
    
    func loginMatrix(
        userId: String,
        password: String,
        homeServer: URL,
        accessToken: String,
        refreshToken: String
    ) {
        matrixUseCase.loginUser(userId: userId, password: password, homeServer: homeServer) { [weak self] result in
            // TODO: Обработать case failure
            guard case .success = result else {
                self?.verificationState = .wrongOTP;
                return
            }
            self?.userSettings.isLocalAuth = true
            self?.keychainService.isApiUserAuthenticated = true
            self?.keychainService.apiAccessToken = accessToken
            self?.keychainService.apiRefreshToken = refreshToken
            self?.userSettings.isAuthFlowFinished = true
            self?.keychainService.isPinCodeEnabled = false
            self?.delegate?.handleNextScene(.main)
        }
    }
}

// MARK: - VerificationPresenterProtocol

extension VerificationPresenter: VerificationPresenterProtocol {
    func onTapResend() {
        guard seconds == 0 else { return }
        resetOtpInput()
        resendPhone()
    }
    
    // MARK: - One Time Password
    
    func getPin(_ index: Int) -> String {
        guard otpCode.count > index else { return "" }
        let indx = String.Index(utf16Offset: index, in: otpCode)
        guard let code = otpCode[safe: indx] else { return "" }
        return String(code)
    }
    
    func limitText() {
        otpCode = String(otpCode.prefix(numberOfInputs))
        
        if verificationState != .inputOTP && otpCode.count < 5 {
            verificationState = .inputOTP
        }
    }
    
    func hyphenOpacity(_ index: Int) -> Double {
        
        if otpCode.count == 5 && verificationState != .sendOTP && verificationState != .wrongOTP {
            logIn(otpCode)
        }
        
        let opacity: Double = otpCode.count <= index ? 1 : 0
        return opacity
    }
    
    func strokeColor(_ index: Int) -> Color {
        // TODO: Обработать эти кейсы
        //        verificationState == .sendPhoneError ||
        //        verificationState == .failure ||
        if verificationState == .wrongOTP && otpCode.count == 5 {
            return .spanishCrimson
        }
        
        return otpCode.count <= index ? .clear : .dodgerBlue
    }
}
