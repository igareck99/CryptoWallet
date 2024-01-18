import SwiftUI

// MARK: - ChatsRouterStatable

protocol ChatsRouterStatable: ObservableObject {
    var path: NavigationPath { get set }
    var childPath: NavigationPath { get set }
    var presentedItem: BaseSheetLink? { get set }
    var coverItem: BaseFullCoverLink? { get set }
    var sheetHeight: CGFloat { get set }
}

final class ChatsRouterState: ChatsRouterStatable {
    static var shared = ChatsRouterState()
    @Published var path = NavigationPath()
    @Published var childPath = NavigationPath()
    @Published var presentedItem: BaseSheetLink?
    @Published var coverItem: BaseFullCoverLink?
    @Published var sheetHeight: CGFloat = 223
}
