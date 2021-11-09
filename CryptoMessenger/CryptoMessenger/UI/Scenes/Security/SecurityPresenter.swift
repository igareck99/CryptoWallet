import Foundation

// MARK: - SecurityPresenter

final class SecurityPresenter {

    // MARK: - Internal Properties

    weak var delegate: SecuritySceneDelegate?
    weak var view: SecurityViewInterface?

    private var state = SecurityFlow.ViewState.sending {
        didSet {
            updateView(state)
        }
    }

    // MARK: - Lifecycle

    init(view: SecurityViewInterface) {
        self.view = view
    }

    // MARK: - Internal Methods

    func updateView(_ state: SecurityFlow.ViewState) {
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

// MARK: - SecurityPresenter (SecurityPresentation)

extension SecurityPresenter: SecurityPresentation {
    func handleButtonTap() {

    }
}
