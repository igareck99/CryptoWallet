import SwiftUI
import UIKit

// MARK: - GroupCallsAssembly

enum GroupCallsAssembly {

    // MARK: - Static Methods

    static func build(delegate: GroupCallsViewControllerDelegate) -> UIViewController {
        let view = GroupCallsViewControllerWrapper(delegate: delegate)
        let controller = UIHostingController(rootView: view)
        return controller
    }
}
