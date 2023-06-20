import SwiftUI
import UIKit

enum P2PCallsAssembly {
    static func build(
        model: P2PCall,
        p2pCallUseCase: P2PCallUseCaseProtocol
    ) -> UIViewController {
        let viewModel = CallViewModel(
            userName: model.activeCallerName,
            roomId: model.roomId,
            selfyView: model.selfyView,
            interlocutorView: model.interlocutorView,
            isVideoCall: model.isVideoCall,
            p2pCallUseCase: p2pCallUseCase
        )

        let callView = P2PCallView(viewModel: viewModel)
        let controller = UIHostingController(rootView: callView)
        return controller
    }
}
