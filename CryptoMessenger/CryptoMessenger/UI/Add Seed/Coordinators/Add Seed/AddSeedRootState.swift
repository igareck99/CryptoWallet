import Combine
import SwiftUI

protocol AddSeedRootStatable: ObservableObject {
    var path: NavigationPath { get set }
    var presentedItem: BaseSheetLink? { get set }

    func update(path: Binding<NavigationPath>)
    func update(presentedItem: Binding<BaseSheetLink?>)
}

final class AddSeedRootState: AddSeedRootStatable {
    @Binding var path: NavigationPath
    @Binding var presentedItem: BaseSheetLink?

    init(
        path: Binding<NavigationPath>,
        presentedItem: Binding<BaseSheetLink?>
    ) {
        self._path = path
        self._presentedItem = presentedItem
    }

    func update(path: Binding<NavigationPath>) {
        _path = path
    }

    func update(presentedItem: Binding<BaseSheetLink?>) {
        _presentedItem = presentedItem
    }
}
