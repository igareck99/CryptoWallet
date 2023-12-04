import SwiftUI
import UIKit

enum GroupCallsAssembly {
    static func build(delegate: GroupCallsViewControllerDelegate) -> UIViewController {
        let view = GroupCallsViewControllerWrapper(delegate: delegate)
        let controller = UIHostingController(rootView: view)
        return controller
    }
}
