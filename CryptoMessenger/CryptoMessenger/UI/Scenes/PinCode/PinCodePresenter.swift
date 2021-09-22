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
            self.userFlows.isOnboardingFlowFinished = true
            self.userFlows.isLocalAuth = false
            self.delegate?.handleNextScene(.main)
        }
        let alert = UIAlertController(title: R.string.localizable.pinCodeAlertTitle(),
                                      message: R.string.localizable.pinCodeAlertMessage(),
                                      preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: R.string.localizable.pinCodeAlertCancel(),
                                      style: UIAlertAction.Style.default,
                                      handler: { _ in
                                        alert.dismiss(animated: true, completion: nil)}))
        alert.addAction(UIAlertAction(title: R.string.localizable.pinCodeAlertYes(),
                                      style: UIAlertAction.Style.default,
                                              handler: {(_: UIAlertAction!) in
                                                self.userFlows.isLocalAuth = false
                }))
        print("self.userFlows.isOnboardingFlowFinished     \(self.userFlows.isOnboardingFlowFinished)")
        print("self.userFlows.isLocalAuth  \(self.userFlows.isLocalAuth)")
        wallet?.present(alert, animated: true, completion: nil)
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
