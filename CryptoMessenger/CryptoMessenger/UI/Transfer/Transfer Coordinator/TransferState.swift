import Combine
import SwiftUI

protocol TransferStatable: ObservableObject {
    var path: NavigationPath { get set }
    var presentedItem: WalletSheetLink? { get set }

    func update(path: Binding<NavigationPath>)
    func update(presentedItem: Binding<WalletSheetLink?>)
}

final class TransferState: TransferStatable {
    @Binding var path: NavigationPath
    @Binding var presentedItem: WalletSheetLink?

    init(
        path: Binding<NavigationPath>,
        presentedItem: Binding<WalletSheetLink?>
    ) {
        self._path = path
        self._presentedItem = presentedItem
    }

    func update(path: Binding<NavigationPath>) {
        _path = path
    }

    func update(presentedItem: Binding<WalletSheetLink?>) {
        _presentedItem = presentedItem
    }
}
