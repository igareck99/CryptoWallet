import SwiftUI

// MARK: - ProfileCoordinatorBase

class ProfileCoordinatorBase: ObservableObject {
static let shared = ProfileCoordinatorBase()
    @Published var path = NavigationPath()
    @Published var presentedItem: ProfileSheetLlink?
    @Published var coverItem: ProfileContentLlink?
}

// MARK: - ProfileFlowState

final class ProfileFlowState: ProfileCoordinatorBase { }
