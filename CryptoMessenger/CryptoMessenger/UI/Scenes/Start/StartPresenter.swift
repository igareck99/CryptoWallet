import Foundation

// MARK: StartPresenterDelegate

protocol StartPresenterDelegate: AnyObject {
    func userNeedsToAuthenticate()
    func userIsAuthenticated()
}

// MARK: - StartPresenter

final class StartPresenter {

    // MARK: - Public Properties

    weak var delegate: StartPresenterDelegate?
    weak var view: StartViewInterface?

    // MARK: - Private Properties

    private let userCredentialsStorage: UserCredentialsStorageService

    // MARK: - Lifecycle

    init(view: StartViewInterface, userCredentialsStorage: UserCredentialsStorageService) {
        self.view = view
        self.userCredentialsStorage = userCredentialsStorage
    }

    // MARK: - Internal Methods

    func checkUserState() {
        view?.startActivity(animated: true)

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            self.view?.stopActivity(animated: true)
            if self.userCredentialsStorage.isUserAuthenticated {
                self.delegate?.userIsAuthenticated()
            } else {
                self.delegate?.userNeedsToAuthenticate()
            }
        }
    }
}

// MARK: - StartPresenter (StartPresentation)

extension StartPresenter: StartPresentation {
    func onViewDidLoad() {
        checkUserState()
    }
}
