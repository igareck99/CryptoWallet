import Foundation

// MARK: - VerificationPresenter

final class VerificationPresenter {

    // MARK: - Internal Properties

    weak var delegate: VerificationSceneDelegate?
    weak var view: VerificationViewInterface?

    // MARK: - Private Properties

    @Injectable private var apiClient: APIClientManager
    @Injectable private var userCredentials: UserCredentialsStorageService
    @Injectable private var countdownTimer: CountdownTimer

    private var state = VerificationFlow.ViewState.sending {
        didSet {
            updateView(state)
        }
    }

    // MARK: - Lifecycle

    init(view: VerificationViewInterface) {
        self.view = view
        countdownTimer.delegate = self
    }

    // MARK: - Private Methods

    private func updateView(_ state: VerificationFlow.ViewState) {
        switch state {
        case let .idle(phone):
            view?.setPhoneNumber(phone)
        case .sending:
            print("sending..")
        case .resend(let time, let isFinished):
            if isFinished {
                view?.resetCountdownTime()
            } else {
                view?.setCountdownTime(time)
            }
        case .result:
            print("result")
        case .error(let message):
            view?.showAlert(title: nil, message: message)
        }
    }

    private func resendPhone() {
        let numbers = userCredentials.userPhoneNumber.numbers
        apiClient.request(Endpoints.Registration.get(numbers)) { [weak self] _ in
            self?.countdownTimer.start()
        } failure: { [weak self] error in
            self?.state = .error(message: error.localizedDescription)
        }
    }
}

// MARK: - VerificationPresenter (VerificationPresentation)

extension VerificationPresenter: VerificationPresentation {
    func viewDidLoad() {
        state = .idle(userCredentials.userPhoneNumber)
        countdownTimer.start()
    }

    func handleResendCode() {
        //resendPhone()
        countdownTimer.stop()
        delay(1.4) {
            self.countdownTimer.start()
        }
    }

    func handleNextScene(_ code: String) {
        guard code == "1234" else { return }
        delegate?.handleNextScene(.generationInfo)
    }
}

// MARK: - VerificationPresenter (CountdownTimerDelegate)

extension VerificationPresenter: CountdownTimerDelegate {
    func countdownTimerDidFinish() {
        state = .resend(PhoneHelper.verificationResendTime.description, true)
    }

    func countdownTime(_ timerResult: TimerResult) {
        state = .resend("\(timerResult.seconds)", false)
    }
}
