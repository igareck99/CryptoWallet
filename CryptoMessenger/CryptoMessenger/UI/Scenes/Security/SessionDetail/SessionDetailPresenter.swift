import Foundation

// MARK: - SessionDetailPresenter

final class SessionDetailPresenter {

    // MARK: - Internal Properties

    weak var delegate: SessionDetailSceneDelegate?
    weak var view: SessionDetailViewInterface?

    private var state = SessionDetailFlow.ViewState.sending {
        didSet {
            updateView(state)
        }
    }

    // MARK: - Lifecycle

    init(view: SessionDetailViewInterface) {
        self.view = view
    }

    // MARK: - Internal Methods

    func updateView(_ state: SessionDetailFlow.ViewState) {
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

// MARK: - SessionDetailPresenter (SessionDetailPresentation)

extension SessionDetailPresenter: SessionDetailPresentation {
    func handleButtonTap() {

    }
}
