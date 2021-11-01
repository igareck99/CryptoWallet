import Foundation

// MARK: - TypographyPresenter

final class TypographyPresenter {

    // MARK: - Internal Properties

    weak var delegate: TypographySceneDelegate?
    weak var view: TypographyViewInterface?

    private var state = TypographyFlow.ViewState.sending {
        didSet {
            updateView(state)
        }
    }

    // MARK: - Lifecycle

    init(view: TypographyViewInterface) {
        self.view = view
    }

    // MARK: - Internal Methods

    func updateView(_ state: TypographyFlow.ViewState) {
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

// MARK: - TypographyPresenter (TypographyPresentation)

extension TypographyPresenter: TypographyPresentation {
    func handleButtonTap() {

    }
}
