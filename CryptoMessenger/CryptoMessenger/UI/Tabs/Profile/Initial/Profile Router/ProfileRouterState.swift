import SwiftUI

protocol ProfileRouterStatable: ObservableObject {
    var path: NavigationPath { get set }
    var presentedItem: BaseSheetLink? { get set }
}

// MARK: - ProfileRouterState

final class ProfileRouterState: ProfileRouterStatable {
    static var shared = ProfileRouterState()
    @Published var path = NavigationPath()
    @Published var presentedItem: BaseSheetLink?
}
