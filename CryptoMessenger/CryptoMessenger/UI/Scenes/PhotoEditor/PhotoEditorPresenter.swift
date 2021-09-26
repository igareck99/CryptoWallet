import UIKit

// MARK: - PhotoEditorPresenter

final class PhotoEditorPresenter {

    // MARK: - Internal Properties

    weak var delegate: PhotoEditorSceneDelegate?
    weak var view: PhotoEditorViewInterface?

    private(set) var images: [UIImage]

    // MARK: - Private Properties

    private var state = PhotoEditorFlow.ViewState.sending {
        didSet {
            updateView(state)
        }
    }

    // MARK: - Lifecycle

    init(view: PhotoEditorViewInterface, images: [UIImage]) {
        self.view = view
        self.images = images
    }

    // MARK: - Internal Methods

    func updateView(_ state: PhotoEditorFlow.ViewState) {
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

// MARK: - PhotoEditorPresenter (PhotoEditorPresentation)

extension PhotoEditorPresenter: PhotoEditorPresentation {
    func handleButtonTap() {

    }
}
