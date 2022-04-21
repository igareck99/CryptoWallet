import Foundation
import UIKit

// MARK: - PinCodePresenter

final class PinCodePresenter {

    // MARK: - Internal Properties

    weak var delegate: PinCodeSceneDelegate?
    weak var view: PinCodeViewInterface?
    private(set) var localAuth = LocalAuthentication()
    private(set) var isLocalAuthBackgroundAlertShown = false

    // MARK: - Private Properties

    private var state = PinCodeFlow.ViewState.sending {
        didSet {
            updateView(state)
        }
    }
    private let userSettings: UserCredentialsStorage & UserFlowsStorage

    // MARK: - Lifecycle

    init(
		view: PinCodeViewInterface,
		userSettings: UserCredentialsStorage & UserFlowsStorage
	) {
        self.view = view
		self.userSettings = userSettings
        isLocalAuthBackgroundAlertShown = userSettings.isLocalAuthBackgroundAlertShown
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
		let pinCode = userSettings.userPinCode?
			.map({ Int(String($0)) })
			.compactMap({ $0 }) ?? []
        let isBiometryOn = userSettings.isBiometryOn
        view?.setPinCode(pinCode)
        view?.setBiometryActive(isBiometryOn)
    }

    func setNewPinCode(_ pinCode: String) {
		userSettings.userPinCode = pinCode
    }

    func checkLocalAuth() {
        DispatchQueue.main.async { self.state = .result(self.localAuth.getAvailableBiometrics()) }
    }

    func handleButtonTap(_ isBackgroundLocalAuth: Bool) {
		userSettings.isLocalAuth = true
		userSettings.isAuthFlowFinished = true
		userSettings.isLocalAuthBackgroundAlertShown = true
		userSettings.isLocalAuthInBackground = isBackgroundLocalAuth
        delay(0.1) { self.delegate?.handleNextScene() }
    }
}
