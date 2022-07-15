import UIKit

enum P2PCallsAssembly {
	static func build(
		model: P2PCall,
		p2pCallUseCase: P2PCallUseCaseProtocol
	) -> UIViewController {
		let viewModel = CallViewModel(
			userName: model.activeCallerName,
			p2pCallUseCase: p2pCallUseCase
		)
		let controller = CallViewController(
			viewModel: viewModel,
			interlocutorCallView: model.interlocutorView,
			selfCallView: model.selfyView
		)
		return controller
	}
}
