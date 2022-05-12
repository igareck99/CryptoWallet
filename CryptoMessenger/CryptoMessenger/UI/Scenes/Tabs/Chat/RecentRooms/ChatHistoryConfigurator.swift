import Foundation
import UIKit

// MARK: - ChatHistoryConfigurator

enum ChatHistoryConfigurator {

    // MARK: - Static Methods

	static func configuredView(delegate: ChatHistorySceneDelegate?) -> UIViewController {
        let viewModel = ChatHistoryViewModel()
        viewModel.delegate = delegate

		let view = ChatHistoryView(viewModel: viewModel)
		let viewController = BaseHostingController(rootView: view)

		return viewController
    }
}
