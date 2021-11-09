import Foundation

// MARK: - BlackListPresenter

final class BlackListPresenter {

    // MARK: - Internal Properties

    weak var delegate: BlackListSceneDelegate?
    weak var view: BlackListViewInterface?

    private var state = BlackListFlow.ViewState.sending {
        didSet {
            updateView(state)
        }
    }

    // MARK: - Lifecycle

    init(view: BlackListViewInterface) {
        self.view = view
    }

    // MARK: - Internal Methods

    func updateView(_ state: BlackListFlow.ViewState) {
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

// MARK: - BlackListPresenter (BlackListPresentation)

extension BlackListPresenter: BlackListPresentation {
    func handleButtonTap() {

    }
}
