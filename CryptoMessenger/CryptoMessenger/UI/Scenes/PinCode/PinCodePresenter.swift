import Foundation
import UIKit

// MARK: - PinCodePresenter

final class PinCodePresenter {

    // MARK: - Internal Properties

    weak var delegate: PinCodeSceneDelegate?
    weak var view: PinCodeViewInterface?
    weak var wallet: WalletViewController?

    // MARK: - Private Properties

    private let localAuth = LocalAuthentication()
    private var state = PinCodeFlow.ViewState.sending {
        didSet {
            updateView(state)
        }
    }

    @Injectable private var userFlows: UserFlowsStorageService

    // MARK: - Lifecycle

    init(view: PinCodeViewInterface) {
        self.view = view
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

    private func showProfile() {
        delay(1) {
            self.delegate?.handleNextScene(.main)
        }
}
}
// MARK: - PinCodePresenter (PinCodePresentation)

extension PinCodePresenter: PinCodePresentation {
    func checkLocalAuth() {
        state = .result(localAuth.getAvailableBiometrics())
    }

    func handleButtonTap() {
        showProfile()
    }
}
