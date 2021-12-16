import Foundation

// MARK: - ProfileNetworkDetailPresenter

final class ProfileNetworkDetailPresenter {

    // MARK: - Internal Properties

    weak var delegate: ProfileNetworkDetailSceneDelegate?
    weak var view: ProfileNetworkDetailViewInterface?

    private var state = ProfileNetworkDetailFlow.ViewState.sending {
        didSet {
            updateView(state)
        }
    }

    // MARK: - Lifecycle

    init(view: ProfileNetworkDetailViewInterface) {
        self.view = view
    }

    // MARK: - Internal Methods

    func updateView(_ state: ProfileNetworkDetailFlow.ViewState) {
        switch state {
        case .sending:
            print("sending..")
        case .result:
            print("result")
        case .error(let message):
            view?.showAlert(title: nil, message: message)
        }
    }

    func backAction() {

    }
}

// MARK: - ProfileNetworkDetailPresenter (ProfileNetworkDetailPresentation)

extension ProfileNetworkDetailPresenter: ProfileNetworkDetailPresentation {
    func handleButtonTap() {
        backAction()
    }
}
