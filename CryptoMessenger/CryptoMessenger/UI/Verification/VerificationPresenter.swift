import Combine
import Foundation
import SwiftUI

// swiftlint:disable all

protocol VerificationSceneDelegate: AnyObject {
    func onVerificationSuccess()
}

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

struct AuraMatrixCredentials {
    let homeServer: String
    let userId: String
    let accessToken: String
    let deviceId: String
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
    private let privateDataCleaner: PrivateDataCleanerProtocol
    private let secondsConstant: Int = 30
    private var timer: Timer?
    var seconds: Int = 30
    let otpCodeCount: Int = 5
    
    init(
        apiClient: APIClientManager = APIClient.shared,
        configuration: ConfigType = Configuration.shared,
        keychainService: KeychainServiceProtocol = KeychainService.shared,
        userSettings: UserCredentialsStorage & UserFlowsStorage = UserDefaultsService.shared,
        matrixUseCase: MatrixUseCaseProtocol = MatrixUseCase.shared,
        resources: CodeVerificationResourcable.Type = CodeVerificationResources.self,
        colors: Colors = VerificationColors(),
        delegate: VerificationSceneDelegate? = nil,
        privateDataCleaner: PrivateDataCleanerProtocol = PrivateDataCleaner()
    ) {
        self.apiClient = apiClient
        self.configuration = configuration
        self.keychainService = keychainService
        self.matrixUseCase = matrixUseCase
        self.resources = resources
        self.colors = colors
        self.userSettings = userSettings
        self.delegate = delegate
        self.privateDataCleaner = privateDataCleaner
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
    
}

// MARK: - Network Requests

private extension VerificationPresenter  {
    
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
    
    // MARK: - JWT Auth
    
    func logInWithJWT(code: String) {
    
        let phone = keychainService.apiUserPhoneNumber?.numbers ?? ""
        debugPrint("logInWithJWT(code: phone \(phone)")
        
        let endpoint = Endpoints.Registration.jwtAuth(
            .init(
                device: .init(name: configuration.deviceName, unique: configuration.deviceId),
                phone: phone,
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
                        debugPrint("logInWithJWT: \(String(describing: err))")
                        self?.verificationState = .wrongOTP
                    default:
                        break
                }
            } receiveValue: { [weak self] response in
                
                // TODO: Обработать отсутсвие userId
                guard let userId = response.userId,
                      let apiAccessToken = response.apiAccessToken,
                      let apiRefreshToken = response.apiRefreshToken,
                      let homeServer = self?.configuration.matrixURL,
                      let deviceId = self?.configuration.deviceId else {
                    self?.verificationState = .wrongOTP
                    return
                }
                
                self?.loginMatrixWithJWT(
                    phone: phone,
                    deviceId: deviceId,
                    userId: userId,
                    homeServer: homeServer,
                    apiAccessToken: apiAccessToken,
                    apiRefreshToken: apiRefreshToken
                )
            }
            .store(in: &subscriptions)
    }
    
    func loginMatrixWithJWT(
        phone: String,
        deviceId: String,
        userId: String,
        homeServer: URL,
        apiAccessToken: String,
        apiRefreshToken: String
    ) {
        matrixUseCase.loginByJWT(
            token: apiAccessToken,
            deviceId: deviceId,
            userId: userId,
            homeServer: homeServer
        ) { [weak self] result in
                
                // TODO: Обработать case failure
                guard case let .success(auraMxCredentials) = result else {
                    self?.verificationState = .wrongOTP;
                    return
                }
                self?.saveLogInState(
                    phone: phone,
                    userId: auraMxCredentials.userId,
                    apiAccessToken: apiAccessToken,
                    apiRefreshToken: apiRefreshToken,
                    homeServer: homeServer.absoluteString,
                    mxCredentials: auraMxCredentials
                )
                self?.delegate?.onVerificationSuccess()
            }
    }
    
    func saveLogInState(
        phone: String,
        userId: String,
        apiAccessToken: String,
        apiRefreshToken: String,
        homeServer: String,
        mxCredentials: AuraMatrixCredentials
    ) {
        debugPrint("MATRIX DEBUG VerificationPresenter saveLogInState")
        privateDataCleaner.clearWalletPrivateData()
        privateDataCleaner.clearMatrixPrivateData()
        userSettings.userId = userId
        userSettings.isLocalAuth = true
        // Пересохраняем телефон под новым service name (serviceName + userMatrixId)
        keychainService.apiUserPhoneNumber = phone
        keychainService.isApiUserAuthenticated = true
        keychainService.apiAccessToken = apiAccessToken
        keychainService.apiRefreshToken = apiRefreshToken
        keychainService.accessToken = mxCredentials.accessToken
        keychainService.deviceId = mxCredentials.deviceId
        keychainService.homeServer = homeServer
        userSettings.isAuthFlowFinished = true
        keychainService.isPinCodeEnabled = false
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
        
        if verificationState != .inputOTP &&
            otpCode.count < otpCodeCount {
            verificationState = .inputOTP
        }
    }
    
    func hyphenOpacity(_ index: Int) -> Double {
        
        if otpCode.count == otpCodeCount &&
            verificationState != .sendOTP &&
            verificationState != .wrongOTP {
            logInWithJWT(code: otpCode)
        }
        
        let opacity: Double = otpCode.count <= index ? 1 : 0
        return opacity
    }
    
    func strokeColor(_ index: Int) -> Color {
        // TODO: Обработать эти кейсы
        //        verificationState == .sendPhoneError ||
        //        verificationState == .failure ||
        if verificationState == .wrongOTP && otpCode.count == otpCodeCount {
            return .spanishCrimson
        }
        
        return otpCode.count <= index ? .clear : .dodgerBlue
    }
}
