import Foundation

// MARK: - SecurityPinCodePresenter

final class SecurityPinCodePresenter {

    // MARK: - Internal Properties

    weak var delegate: SecurityPinCodeSceneDelegate?
    weak var view: SecurityPinCodeViewInterface?

    private var state = SecurityPinCodeFlow.ViewState.sending {
        didSet {
            updateView(state)
        }
    }

    @Injectable private var userFlows: UserFlowsStorageService
    @Injectable private var userCredentials: UserCredentialsStorageService

    // MARK: - Lifecycle

    init(view: SecurityPinCodeViewInterface) {
        self.view = view
    }

    // MARK: - Internal Methods

    func updateView(_ state: SecurityPinCodeFlow.ViewState) {
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

// MARK: - SecurityPinCodePresenter (SecurityPinCodePresentation)

extension SecurityPinCodePresenter: SecurityPinCodePresentation {
    func viewDidLoad() {
        if falsePasswordCalled && userFlows.isFalsePinCodeOn {
            userCredentials.userFalsePinCode = ""
            let pinCode = userCredentials.userFalsePinCode.map({ Int(String($0)) }).compactMap({ $0 })
            view?.setPinCode(pinCode)
        } else {
            let pinCode = userCredentials.userPinCode.map({ Int(String($0)) }).compactMap({ $0 })
            view?.setPinCode(pinCode)
        }
    }

    func setNewPinCode(_ pinCode: String) {
        if userFlows.isFalsePinCodeOn && falsePasswordCalled {
            userCredentials.userFalsePinCode = pinCode
        } else {
            userCredentials.userPinCode = pinCode
        }
    }

    func handleButtonTap(_ isBackgroundLocalAuth: Bool) {
        userFlows.isLocalAuth = true
        userFlows.isAuthFlowFinished = true
        userFlows.isLocalAuthBackgroundAlertShown = true
        userFlows.isLocalAuthInBackground = isBackgroundLocalAuth
        delay(0.1) { self.delegate?.handleNextScene() }
    }
}
