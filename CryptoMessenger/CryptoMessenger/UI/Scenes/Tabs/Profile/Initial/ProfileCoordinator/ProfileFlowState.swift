import SwiftUI

// MARK: - ProfileCoordinatorBase

class ProfileCoordinatorBase: ObservableObject {

    @Published var path = NavigationPath()
    @Published var presentedItem: ProfileSheetLlink?
    @Published var coverItem: ProfileContentLlink?
}

// MARK: - ProfileFlowState

final class ProfileFlowState: ProfileCoordinatorBase {
    static var shared = ProfileFlowState()
}
