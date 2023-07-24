import Combine
import SwiftUI

protocol AuthStatable: ObservableObject {
    var path: NavigationPath { get set }
    var presentedItem: AuthSheetLink? { get set }
}

final class AuthState: AuthStatable {
    static let shared = AuthState()
    @Published var path = NavigationPath()
    @Published var presentedItem: AuthSheetLink?
}