import Foundation

// MARK: - FriendProfilePresenter

final class FriendProfilePresenter {

    // MARK: - Internal Properties

    weak var delegate: FriendProfileSceneDelegate?
    weak var view: FriendProfileViewInterface?

    private var state = FriendProfileFlow.ViewState.sending {
        didSet {
            updateView(state)
        }
    }

    // MARK: - Lifecycle

    init(view: FriendProfileViewInterface) {
        self.view = view
    }

    // MARK: - Internal Methods

    func updateView(_ state: FriendProfileFlow.ViewState) {
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

// MARK: - FriendProfilePresenter (FriendProfilePresentation)

extension FriendProfilePresenter: FriendProfilePresentation {
    func handleButtonTap() {

    }
}
