import UIKit

// MARK: - ProfilePresenter

final class ProfilePresenter {
    // MARK: - Types

    // MARK: - Internal Properties

    weak var delegate: ProfileSceneDelegate?
    weak var view: ProfileViewInterface?

    // MARK: - Private Properties

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
        case let .result(photos):
            view?.setPhotos(photos)
        case .error(let message):
            view?.showAlert(title: nil, message: message)
        }
    }
}

// MARK: - ProfilePresenter (ProfilePresentation)

extension ProfilePresenter: ProfilePresentation {
    func viewDidLoad() {
        state = .result(mockPhotos)
    }

    func handleButtonTap() {

    }
}

private var mockPhotos: [UIImage?] = [
    R.image.profile.testpicture2(),
    R.image.profile.testpicture3(),
    R.image.profile.testpicture4(),
    R.image.profile.testpicture5()
]
