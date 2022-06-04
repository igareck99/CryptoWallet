import UIKit

enum P2PCallsAssembly {
	static func build(
		userName: String,
		p2pCallUseCase: P2PCallUseCaseProtocol
	) -> UIViewController {
		let viewModel = CallViewModel(
			userName: userName,
			p2pCallUseCase: p2pCallUseCase
		)
		let controller = CallViewController(viewModel: viewModel)
		return controller
	}
}
