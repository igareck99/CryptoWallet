import Combine
import Foundation

// MARK: - VerificationPresenter

final class VerificationPresenter {

    // MARK: - Internal Properties

    weak var delegate: VerificationSceneDelegate?
    weak var view: VerificationViewInterface?

    // MARK: - Private Properties

    @Injectable private var apiClient: APIClientManager
    @Injectable private var countdownTimer: CountdownTimer
    @Injectable private var configuration: Configuration
    private let matrixUseCase: MatrixUseCaseProtocol
    private var subscriptions = Set<AnyCancellable>()
	private let userCredentials: UserCredentialsStorage

    private var state = VerificationFlow.ViewState.sending {
        didSet {
            updateView(state)
        }
    }

    // MARK: - Lifecycle

    init(
		view: VerificationViewInterface,
		userCredentials: UserCredentialsStorage,
		matrixUseCase: MatrixUseCaseProtocol
	) {
        self.view = view
		self.userCredentials = userCredentials
		self.matrixUseCase = matrixUseCase
        countdownTimer.delegate = self
    }

    // MARK: - Private Methods

    private func updateView(_ state: VerificationFlow.ViewState) {
        switch state {
        case let .idle(phone):
            view?.setPhoneNumber(phone)
        case .sending:
            debugPrint("sending..")
        case .resend(let time, let isFinished):
            if isFinished {
                view?.resetCountdownTime()
            } else {
                view?.setCountdownTime(time)
            }
        case .result:
            debugPrint("result")
        case .error(let message):
            view?.showAlert(title: nil, message: message)
        }
    }

    private func resendPhone() {
        apiClient
            .publisher(Endpoints.Registration.sms(userCredentials.userPhoneNumber?.numbers ?? ""))
            .sink { [weak self] completion in
                switch completion {
                case .failure(let error):
                    guard let err = error as? APIError else {
                        self?.state = .error(message: APIError.serverError.localizedDescription)
                        return
                    }
                    self?.state = .error(message: err.localizedDescription)
                default:
                    break
                }
            } receiveValue: { [weak self] _ in
                self?.countdownTimer.start()
            }
            .store(in: &subscriptions)
    }

    private func logIn(_ code: String) {
        let endpoint = Endpoints.Registration.auth(
            .init(
                device: .init(name: configuration.deviceName, unique: configuration.deviceId),
                phone: userCredentials.userPhoneNumber?.numbers ?? "",
                sms: code
            )
        )

        let homeServer = configuration.matrixURL

        apiClient
            .publisher(endpoint)
            .sink { [weak self] completion in
                self?.view?.setResult(false)
                switch completion {
                case .failure(let error):
                    guard let err = error as? APIError else {
                        self?.state = .error(message: APIError.serverError.localizedDescription)
                        return
                    }
                    self?.state = .error(message: err.localizedDescription)
                default:
                    break
                }
            } receiveValue: { [weak self] response in

				// TODO: Обработать отсутсвие userId
				guard let userId = response.userId,
					  let password = response.matrixPassword else {
					return
					debugPrint("VerificationPresenter: logInV2: FAILED response: \(response)")
				}

				self?.matrixUseCase.loginUser(
					userId: userId,
					password: password,
					homeServer: homeServer) { result in
						// TODO: Обработать case failure
						guard case .success = result else { return }
						self?.view?.setResult(true)
						self?.userCredentials.isUserAuthenticated = true
						self?.userCredentials.accessToken = response.accessToken
						self?.userCredentials.refreshToken = response.refreshToken
						self?.delegate?.handleNextScene(.pinCode)
					}
            }
            .store(in: &subscriptions)
    }
}

// MARK: - VerificationPresenter (VerificationPresentation)

extension VerificationPresenter: VerificationPresentation {
    func viewDidLoad() {
        state = .idle(userCredentials.userPhoneNumber ?? "")
        countdownTimer.start()
    }

    func handleResendCode() {
        countdownTimer.stop()
        resendPhone()
        countdownTimer.start()
    }

    func handleNextScene(_ code: String) {
       logIn(code)
    }
}

// MARK: - VerificationPresenter (CountdownTimerDelegate)

extension VerificationPresenter: CountdownTimerDelegate {
    func countdownTimerDidFinish() {
        state = .resend(PhoneHelper.verificationResendTime.description, true)
    }

    func countdownTime(_ timerResult: TimerResult) {
        if timerResult.seconds[0] == "0" {
            state = .resend("\(timerResult.seconds[1])", false)
        } else {
            state = .resend("\(timerResult.seconds)", false)
        }
    }
}
