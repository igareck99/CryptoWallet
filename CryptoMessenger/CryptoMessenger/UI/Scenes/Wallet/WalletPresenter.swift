import Foundation

// MARK: - WalletPresenter

final class WalletPresenter {

    // MARK: - Internal Properties

    weak var delegate: WalletSceneDelegate?
    weak var view: WalletViewInterface?

    private var state = WalletFlow.ViewState.sending {
        didSet {
            updateView(state)
        }
    }

    // MARK: - Lifecycle

    init(view: WalletViewInterface) {
        self.view = view
    }

    // MARK: - Private Methods

    private func updateView(_ state: WalletFlow.ViewState) {
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

// MARK: - WalletPresenter (WalletPresentation)

extension WalletPresenter: WalletPresentation {
    func handleButtonTap() {

    }
}
