import Foundation

// MARK: - ChatPresenter

final class ChatPresenter {

    // MARK: - Internal Properties

    weak var delegate: ChatSceneDelegate?
    weak var view: ChatViewInterface?

    private var state = ChatFlow.ViewState.sending {
        didSet {
            updateView(state)
        }
    }

    // MARK: - Lifecycle

    init(view: ChatViewInterface) {
        self.view = view
    }

    // MARK: - Private Methods

    private func updateView(_ state: ChatFlow.ViewState) {
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

// MARK: - ChatPresenter (ChatPresentation)

extension ChatPresenter: ChatPresentation {
    func handleButtonTap() {

    }
}
