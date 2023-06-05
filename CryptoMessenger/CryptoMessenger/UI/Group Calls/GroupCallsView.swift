import JitsiMeetSDK
import SwiftUI

struct GroupCallsViewControllerWrapper: UIViewControllerRepresentable {
    weak var delegate: GroupCallsViewControllerDelegate?

    func makeUIViewController(context: Context) -> GroupCallsViewController {
        let viewController = GroupCallsViewController()
        viewController.delegate = delegate
        return viewController
    }

    func updateUIViewController(_ uiViewController: GroupCallsViewController, context: Context) {
    }
}
