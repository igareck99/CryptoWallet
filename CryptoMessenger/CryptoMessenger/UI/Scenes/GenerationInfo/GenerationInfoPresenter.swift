import Foundation

// MARK: - GenerationInfoPresenter

final class GenerationInfoPresenter {

    // MARK: - Internal Properties

    weak var delegate: GenerationInfoSceneDelegate?
    weak var view: KeyGenerationViewInterface?

    private var state = GenerationInfoFlow.ViewState.sending {
        didSet {
            updateView(state)
        }
    }

    // MARK: - Lifecycle

    init(view: KeyGenerationViewInterface) {
        self.view = view
    }

    // MARK: - Private Methods

    private func updateView(_ state: GenerationInfoFlow.ViewState) {
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

// MARK: - GenerationInfoPresenter (GenerationInfoPresentation)

extension GenerationInfoPresenter: KeyGenerationPresentation {
    func handleCreateButtonTap() {
        delegate?.handleNextScene(.keyImport)
    }

    func handleImportButtonTap() {
        delegate?.handleNextScene(.keyImport)
    }
}
