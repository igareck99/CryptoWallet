import Foundation

// MARK: - KeyImportPresenter

final class KeyImportPresenter {

    // MARK: - Internal Properties

    weak var delegate: KeyImportSceneDelegate?
    weak var view: KeyImportViewInterface?

    // MARK: - Private Properties

    private let userFlows: UserFlowsStorage

    private var state = KeyImportFlow.ViewState.sending {
        didSet {
            updateView(state)
        }
    }

    // MARK: - Lifecycle

    init(
		view: KeyImportViewInterface,
		userFlows: UserFlowsStorage
	) {
        self.view = view
		self.userFlows = userFlows
    }

    // MARK: - Private Methods

    private func updateView(_ state: KeyImportFlow.ViewState) {
        switch state {
        case .sending:
            break
        case .result:
            debugPrint("result")
        case .error(let message):
            view?.showAlert(title: nil, message: message)
        }
    }

    private func sendKey() {
        delay(1.4) {
            self.userFlows.isAuthFlowFinished = true
            self.delegate?.handleNextScene(.main)
        }
    }
}

// MARK: - KeyImportPresenter (KeyImportPresentation)

extension KeyImportPresenter: KeyImportPresentation {
    func handleImportButtonTap() {
        sendKey()
    }
}
