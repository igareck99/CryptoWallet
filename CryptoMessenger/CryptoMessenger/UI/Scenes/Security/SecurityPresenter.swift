import Foundation

// MARK: - SecurityPresenter

final class SecurityPresenter {

    // MARK: - Internal Properties

    weak var delegate: SecuritySceneDelegate?
    weak var view: SecurityViewInterface?
    private var state = SecurityFlow.ViewState.sending {
        didSet {
            updateView(state)
        }
    }
    private(set) var localAuth = LocalAuthentication()
    private(set) var isLocalAuthBackgroundAlertShown = false

    @Injectable private var userFlows: UserFlowsStorageService
    @Injectable private var userCredentials: UserCredentialsStorageService

    // MARK: - Lifecycle

    init(view: SecurityViewInterface) {
        self.view = view
        isLocalAuthBackgroundAlertShown = userFlows.isLocalAuthBackgroundAlertShown
    }

    // MARK: - Internal Methods

    func updateView(_ state: SecurityFlow.ViewState) {
        switch state {
        case .sending:
            print("sending..")
        case .result:
            print("result")
        case .error(let message):
            view?.showAlert(title: nil, message: message)
        }
    }
}

// MARK: - SecurityPresenter (SecurityPresentation)

extension SecurityPresenter: SecurityPresentation {
    func checkLocalAuth() {
        DispatchQueue.main.async { self.state = .result(self.localAuth.getAvailableBiometrics()) }
    }

    func handleButtonTap(_ isBackgroundLocalAuth: Bool) {
        userFlows.isLocalAuth = true
        userFlows.isAuthFlowFinished = true
        userFlows.isLocalAuthBackgroundAlertShown = true
        userFlows.isLocalAuthInBackground = isBackgroundLocalAuth
        delay(0.1) { self.delegate?.handleNextScene(.security) }
    }
}
