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
	private let keychainService: KeychainServiceProtocol

    // MARK: - Lifecycle

    init(
		view: PinCodeViewInterface,
		userSettings: UserCredentialsStorage & UserFlowsStorage,
		keychainService: KeychainServiceProtocol
	) {
        self.view = view
		self.userSettings = userSettings
		self.keychainService = keychainService
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
		let pinCode = keychainService.apiUserPinCode?
			.map({ Int(String($0)) })
			.compactMap({ $0 }) ?? []
        let isBiometryOn = userSettings.isBiometryOn
        view?.setPinCode(pinCode)
        view?.setBiometryActive(isBiometryOn)
    }

    func setNewPinCode(_ pinCode: String) {
		keychainService.apiUserPinCode = pinCode
    }

    func checkLocalAuth() {
        DispatchQueue.main.async { self.state = .result(self.localAuth.getAvailableBiometrics()) }
    }

    func handleButtonTap(_ isBackgroundLocalAuth: Bool) {
		userSettings.isLocalAuth = true
		userSettings.isAuthFlowFinished = true
		userSettings.isLocalAuthBackgroundAlertShown = true
		userSettings.isLocalAuthInBackground = isBackgroundLocalAuth
        delegate?.handleNextScene() 
    }
}
