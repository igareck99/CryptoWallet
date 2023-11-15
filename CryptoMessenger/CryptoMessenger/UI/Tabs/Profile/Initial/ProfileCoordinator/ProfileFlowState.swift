import SwiftUI

protocol ProfileFlowStatable: ObservableObject {
    var path: NavigationPath { get set }
    var presentedItem: ProfileSheetLlink? { get set }
    var coverItem: ProfileContentLlink? { get set }
}

// MARK: - ProfileFlowState

final class ProfileFlowState: ProfileFlowStatable {
    static var shared = ProfileFlowState()
    @Published var path = NavigationPath()
    @Published var presentedItem: ProfileSheetLlink?
    @Published var coverItem: ProfileContentLlink?
}
