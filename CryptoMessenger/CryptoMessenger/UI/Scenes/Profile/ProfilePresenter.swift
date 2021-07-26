import Foundation

// MARK: - ProfilePresenter

final class ProfilePresenter {

    // MARK: - Internal Properties

    weak var delegate: ProfileSceneDelegate?
    weak var view: ProfileViewInterface?

    private var state = ProfileFlow.ViewState.sending {
        didSet {
            updateView(state)
        }
    }

    // MARK: - Lifecycle

    init(view: ProfileViewInterface) {
        self.view = view
    }

    // MARK: - Private Methods

    private func updateView(_ state: ProfileFlow.ViewState) {
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

// MARK: - ProfilePresenter (ProfilePresentation)

extension ProfilePresenter: ProfilePresentation {
    func handleButtonTap() {

    }
}
