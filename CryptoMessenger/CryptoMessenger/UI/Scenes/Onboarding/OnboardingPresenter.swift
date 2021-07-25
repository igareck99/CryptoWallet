import Foundation

// MARK: - OnboardingPresenter

final class OnboardingPresenter {

    // MARK: - Internal Properties

    weak var delegate: OnboardingSceneDelegate?
    weak var view: OnboardingViewInterface?

    private var state = OnboardingFlow.ViewState.sending {
        didSet {
            updateView(state)
        }
    }

    // MARK: - Lifecycle

    init(view: OnboardingViewInterface) {
        self.view = view
    }

    // MARK: - Private Methods

    private func updateView(_ state: OnboardingFlow.ViewState) {
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

// MARK: - OnboardingPresenter (OnboardingPresentation)

extension OnboardingPresenter: OnboardingPresentation {
    func handleNextScene() {}
}
