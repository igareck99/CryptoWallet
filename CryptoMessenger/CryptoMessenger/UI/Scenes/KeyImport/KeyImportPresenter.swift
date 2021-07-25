import Foundation

// MARK: - KeyImportPresenter

final class KeyImportPresenter {

    // MARK: - Internal Properties

    weak var delegate: KeyImportSceneDelegate?
    weak var view: KeyImportViewInterface?

    private var state = KeyImportFlow.ViewState.sending {
        didSet {
            updateView(state)
        }
    }

    // MARK: - Lifecycle

    init(view: KeyImportViewInterface) {
        self.view = view
    }

    // MARK: - Private Methods

    private func updateView(_ state: KeyImportFlow.ViewState) {
        switch state {
        case .sending:
            print("sending..")
        case .result:
            print("result")
        case .error(let message):
            view?.showAlert(title: nil, message: message)
        }
    }

    private func sendKey() {
        delay(1.4) {
            self.delegate?.handleNextScene(.verification)
        }
    }
}

// MARK: - KeyImportPresenter (KeyImportPresentation)

extension KeyImportPresenter: KeyImportPresentation {
    func handleImportButtonTap() {
        sendKey()
    }
}
