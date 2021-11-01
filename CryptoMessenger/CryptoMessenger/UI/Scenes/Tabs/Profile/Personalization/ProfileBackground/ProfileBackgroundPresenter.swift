import UIKit

// MARK: - ProfileBackgroundPresenter

final class ProfileBackgroundPresenter {

    // MARK: - Internal Properties

    weak var delegate: ProfileBackgroundSceneDelegate?
    weak var view: ProfileBackgroundViewInterface?

    private var state = ProfileBackgroundFlow.ViewState.sending {
        didSet {
            updateView(state)
        }
    }

    // MARK: - Lifecycle

    init(view: ProfileBackgroundViewInterface) {
        self.view = view
    }

    // MARK: - Internal Methods

    private func updateView(_ state: ProfileBackgroundFlow.ViewState) {
        switch state {
        case .sending:
            break
        case let .result(photos):
            view?.setPhotos(photos)
        case .error(let message):
            view?.showAlert(title: nil, message: message)
        }
    }
}

// MARK: - ProfileBackgroundPresenter (ProfilePresentation)

extension ProfileBackgroundPresenter: ProfileBackgroundPresentation {
    func viewDidLoad() {
        state = .result(mockPhotos)
    }

    func handleButtonTap() {

    }
}

private var mockPhotos: [UIImage?] = [
    R.image.profileBackground.image1(),
    R.image.profileBackground.image2(),
    R.image.profileBackground.image3(),
    R.image.profileBackground.image4(),
    R.image.profileBackground.image5(),
    R.image.profileBackground.image6(),
    R.image.profileBackground.image7()
]
