import Combine
import SwiftUI

protocol AppRouterStatable: ObservableObject {
    var path: NavigationPath { get set }
}

final class AppRouterState: AppRouterStatable {
    static let shared = AppRouterState()
    @Published var path = NavigationPath()
}
