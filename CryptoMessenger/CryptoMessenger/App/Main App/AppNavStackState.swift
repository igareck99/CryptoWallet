import Combine
import SwiftUI

final class AppNavStackState: ObservableObject {
    static let shared = AppNavStackState()
    @Published var path = NavigationPath()
}
