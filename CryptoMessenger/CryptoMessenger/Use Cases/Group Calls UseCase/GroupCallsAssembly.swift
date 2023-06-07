import SwiftUI

// MARK: - GroupCallsAssembly

enum GroupCallsAssembly {

    // MARK: - Static Methods

    static func build(delegate: GroupCallsViewControllerDelegate) -> UIViewController {
        let view = GroupCallsViewControllerWrapper(delegate: delegate)
        let controller = BaseHostingController(rootView: view)
        return controller
    }
}
