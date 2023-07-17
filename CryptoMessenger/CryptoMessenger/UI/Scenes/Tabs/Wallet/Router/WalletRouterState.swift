import Combine
import SwiftUI

protocol WalletRouterStatable: ObservableObject {
    var path: NavigationPath { get set }
    var presentedItem: WalletSheetLink? { get set }
    var coverItem: WalletContentLink? { get set }
}

final class WalletRouterState: WalletRouterStatable {
    static let shared = WalletRouterState()
    @Published var path = NavigationPath()
    @Published var presentedItem: WalletSheetLink?
    @Published var coverItem: WalletContentLink?
}
