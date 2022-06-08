import UIKit

enum P2PCallsAssembly {
	static func build(
		userName: String,
		p2pCallType: P2PCallType,
		p2pCallUseCase: P2PCallUseCaseProtocol
	) -> UIViewController {
		let viewModel = CallViewModel(
			userName: userName,
			p2pCallType: p2pCallType,
			p2pCallUseCase: p2pCallUseCase
		)
		p2pCallUseCase.delegate = viewModel
		let controller = CallViewController(viewModel: viewModel)
		return controller
	}
}
