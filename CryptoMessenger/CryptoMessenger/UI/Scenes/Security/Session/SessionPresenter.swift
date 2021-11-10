import Foundation

// MARK: - SessionPresenter

final class SessionPresenter {

    // MARK: - Internal Properties

    weak var delegate: SessionSceneDelegate?
    weak var view: SessionViewInterface?

    private var state = SessionFlow.ViewState.sending {
        didSet {
            updateView(state)
        }
    }

    // MARK: - Lifecycle

    init(view: SessionViewInterface) {
        self.view = view
    }

    // MARK: - Internal Methods

    func updateView(_ state: SessionFlow.ViewState) {
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

// MARK: - SessionPresenter (SessionPresentation)

extension SessionPresenter: SessionPresentation {
    func handleButtonTap() {

    }
}
