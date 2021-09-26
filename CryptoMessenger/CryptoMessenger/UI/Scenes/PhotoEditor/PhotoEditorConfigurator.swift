import UIKit

// MARK: - PhotoEditorConfigurator

enum PhotoEditorConfigurator {

    // MARK: - Static Methods

    static func configuredViewController(
        images: [UIImage],
        delegate: PhotoEditorSceneDelegate?
    ) -> PhotoEditorViewController {
        let viewController = PhotoEditorViewController()
        let presenter = PhotoEditorPresenter(view: viewController, images: images)
        presenter.delegate = delegate
        viewController.presenter = presenter
        return viewController
    }
}
