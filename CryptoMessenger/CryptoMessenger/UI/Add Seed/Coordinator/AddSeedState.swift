import SwiftUI

protocol AddSeedStatable: ObservableObject {
    var path: NavigationPath { get set }
    var presentedItem: WalletSheetLink? { get set }
}

final class AddSeedState: AddSeedStatable {
    static let shared = AddSeedState()
    @Published var path = NavigationPath()
    @Published var presentedItem: WalletSheetLink?
}
