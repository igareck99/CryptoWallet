import Foundation

// MARK: - PersonalizationPresenter

final class PersonalizationPresenter {

    // MARK: - Internal Properties

    weak var delegate: PersonalizationSceneDelegate?
    weak var view: PersonalizationViewInterface?

    private var state = PersonalizationFlow.ViewState.sending {
        didSet {
            updateView(state)
        }
    }

    // MARK: - Lifecycle

    init(view: PersonalizationViewInterface) {
        self.view = view
    }

    // MARK: - Internal Methods

    func updateView(_ state: PersonalizationFlow.ViewState) {
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

// MARK: - PersonalizationPresenter (PersonalizationPresentation)

extension PersonalizationPresenter: PersonalizationPresentation {
    func handleButtonTap() {

    }
}
