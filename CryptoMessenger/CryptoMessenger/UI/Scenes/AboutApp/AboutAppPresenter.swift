import Foundation

// MARK: - AboutAppPresenter

final class AboutAppPresenter {

    // MARK: - Internal Properties

    weak var delegate: AboutAppSceneDelegate?
    weak var view: AboutAppViewInterface?

    private var state = AboutAppFlow.ViewState.sending {
        didSet {
            updateView(state)
        }
    }

    // MARK: - Lifecycle

    init(view: AboutAppViewInterface) {
        self.view = view
    }

    // MARK: - Internal Methods

    func updateView(_ state: AboutAppFlow.ViewState) {
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

// MARK: - AboutAppPresenter (AboutAppPresentation)

extension AboutAppPresenter: AboutAppPresentation {
    func handleButtonTap() {

    }
}
