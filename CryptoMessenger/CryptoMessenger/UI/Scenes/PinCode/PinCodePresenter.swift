import Foundation
import UIKit
// MARK: - PinCodePresenter

final class PinCodePresenter {

    // MARK: - Internal Properties

    weak var delegate: PinCodeSceneDelegate?
    weak var view: PinCodeViewInterface?
    var localAuth = LocalAuthentication()

    private var state = PinCodeFlow.ViewState.sending {
        didSet {
            updateView(state)
        }
    }

    // MARK: - Lifecycle

    init(view: PinCodeViewInterface) {
        self.view = view
    }

    // MARK: - Private Methods

    private func updateView(_ state: PinCodeFlow.ViewState) {
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

// MARK: - PinCodePresenter (PinCodePresentation)

extension PinCodePresenter: PinCodePresentation {
    func checkLocalAuth() -> AuthState {
        var authstate = AuthState()
        authstate.name = localAuth.getAvailableBiometrics()?.name
        authstate.image = localAuth.getAvailableBiometrics()?.image
        return authstate
    }

    func handleButtonTap() {

    }
}
