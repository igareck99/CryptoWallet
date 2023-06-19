import SwiftUI

// MARK: - ChatHistoryFlowViewModel

struct ChatHistoryFlowViewModel: ViewGeneratable {
    let id = UUID()
    var delegate: ChatHistorySceneDelegate

    func view() -> AnyView {
        return ChatHistoryAssembly.build(delegate).anyView()
    }
}

struct WalletFlowViewModel: ViewGeneratable {
    let id = UUID()
    var delegate: WalletSceneDelegate
    var onTransactionEndHelper: (@escaping (TransactionResult) -> Void) -> Void

    func view() -> AnyView {
        return WalletAssembly.build(delegate,
                                    onTransactionEndHelper: onTransactionEndHelper).anyView()
    }
}

struct ProfileFlowViewModel: ViewGeneratable {
    let id = UUID()
    var delegate: ProfileSceneDelegate
    
    func view() -> AnyView {
        return ProfileAssembly.configuredView(delegate).anyView()
    }
}
