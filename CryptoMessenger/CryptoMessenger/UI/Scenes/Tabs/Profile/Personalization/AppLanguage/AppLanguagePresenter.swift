import Foundation

// MARK: - AppLanguagePresenter

final class AppLanguagePresenter {

    // MARK: - Internal Properties

    weak var delegate: AppLanguageSceneDelegate?
    weak var view: AppLanguageViewInterface?

    private var state = AppLanguageFlow.ViewState.sending {
        didSet {
            updateView(state)
        }
    }

    // MARK: - Lifecycle

    init(view: AppLanguageViewInterface) {
        self.view = view
    }

    // MARK: - Internal Methods

    func updateView(_ state: AppLanguageFlow.ViewState) {
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

// MARK: - AppLanguagePresenter (AppLanguagePresentation)

extension AppLanguagePresenter: AppLanguagePresentation {
    func handleButtonTap() {

    }
}
