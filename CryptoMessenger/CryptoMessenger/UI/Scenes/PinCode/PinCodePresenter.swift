import Foundation
import UIKit

// MARK: - PinCodePresenter

final class PinCodePresenter {

    // MARK: - Internal Properties

    weak var delegate: PinCodeSceneDelegate?
    weak var view: PinCodeViewInterface?
    weak var wallet: WalletViewController?
    private(set) var localAuth = LocalAuthentication()
    private(set) var isLocalAuthBackgroundAlertShown = false

    // MARK: - Private Properties

    private var state = PinCodeFlow.ViewState.sending {
        didSet {
            updateView(state)
        }
    }

    @Injectable private var userFlows: UserFlowsStorageService
    @Injectable private var userCredentials: UserCredentialsStorageService

    // MARK: - Lifecycle

    init(view: PinCodeViewInterface) {
        self.view = view
        isLocalAuthBackgroundAlertShown = userFlows.isLocalAuthBackgroundAlertShown
    }

    // MARK: - Private Methods

    private func updateView(_ state: PinCodeFlow.ViewState) {
        switch state {
        case .sending:
            break
        case let .result(result):
            view?.setLocalAuth(result)
        case .error(let message):
            view?.showAlert(title: nil, message: message)
        }
    }
}

// MARK: - PinCodePresenter (PinCodePresentation)

extension PinCodePresenter: PinCodePresentation {
    func viewDidLoad() {
        let pinCode = userCredentials.userPinCode.map({ Int(String($0)) }).compactMap({ $0 })
        view?.setPinCode(pinCode)
    }

    func setNewPinCode(_ pinCode: String) {
        userCredentials.userPinCode = pinCode
    }

    func checkLocalAuth() {
        DispatchQueue.main.async { self.state = .result(self.localAuth.getAvailableBiometrics()) }
    }

    func handleButtonTap(_ isBackgroundLocalAuth: Bool) {
        userFlows.isLocalAuth = true
        userFlows.isAuthFlowFinished = true
        userFlows.isLocalAuthBackgroundAlertShown = true
        userFlows.isLocalAuthInBackground = isBackgroundLocalAuth
        delay(0.1) { self.delegate?.handleNextScene() }
    }
}
