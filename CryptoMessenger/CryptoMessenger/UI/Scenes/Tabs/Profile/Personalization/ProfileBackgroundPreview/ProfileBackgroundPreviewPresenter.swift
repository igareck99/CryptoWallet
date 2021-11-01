import Foundation

// MARK: - ProfileBackgroundPreviewPresenter

final class ProfileBackgroundPreviewPresenter {

    // MARK: - Internal Properties

    weak var delegate: ProfileBackgroundPreviewSceneDelegate?
    weak var view: ProfileBackgroundPreviewViewInterface?

    private var state = ProfileBackgroundPreviewFlow.ViewState.sending {
        didSet {
            updateView(state)
        }
    }

    // MARK: - Lifecycle

    init(view: ProfileBackgroundPreviewViewInterface) {
        self.view = view
    }

    // MARK: - Internal Methods

    func updateView(_ state: ProfileBackgroundPreviewFlow.ViewState) {
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

// MARK: - ProfileBackgroundPreviewPresenter (ProfileBackgroundPreviewPresentation)

extension ProfileBackgroundPreviewPresenter: ProfileBackgroundPreviewPresentation {
    func handleButtonTap() {

    }
}
