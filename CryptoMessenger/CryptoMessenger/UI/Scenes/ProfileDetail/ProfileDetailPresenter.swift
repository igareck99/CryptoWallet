import Foundation

// MARK: - ProfileDetailPresenter

final class ProfileDetailPresenter {

    // MARK: - Internal Properties

    weak var delegate: ProfileDetailSceneDelegate?
    weak var view: ProfileDetailViewInterface?

    private var state = ProfileDetailFlow.ViewState.sending {
        didSet {
            updateView(state)
        }
    }

    // MARK: - Lifecycle

    init(view: ProfileDetailViewInterface) {
        self.view = view
    }

    // MARK: - Internal Methods

    func updateView(_ state: ProfileDetailFlow.ViewState) {
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
        self.delegate?.handleNextScene(.main)
    }
}

// MARK: - ProfileDetailPresenter (ProfileDetailPresentation)

extension ProfileDetailPresenter: ProfileDetailPresentation {
    func handleButtonTap() {
        backAction()
    }
}
