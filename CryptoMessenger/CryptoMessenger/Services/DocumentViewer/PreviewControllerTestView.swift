import QuickLook
import SwiftUI
import UIKit

// MARK: - PreviewControllerTestView(UIViewControllerRepresentable)

struct PreviewControllerTestView: UIViewControllerRepresentable {

    // MARK: - Internal Properties

    @ObservedObject var viewModel: DocumentViewerViewModel
    var previewItems: [PreviewDocumentItem] = []
    var index = 0

    // MARK: - Internal Methods

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func updateUIViewController(_ viewController: UINavigationController,
                                context: UIViewControllerRepresentableContext<Self>) {
        if !viewModel.isUploadFinished {
            let activityIndicatior = UIActivityIndicatorView()
            activityIndicatior.frame(forAlignmentRect: CGRect(x: 100,
                                                              y: 100,
                                                              width: 100,
                                                              height: 100))
            viewController.topViewController?.view.addSubview(activityIndicatior)
        }
        (viewController.topViewController as? QLPreviewController)
    }

    func makeUIViewController(context: Context) -> UINavigationController {
        let controller = QLPreviewController()
        controller.dataSource = context.coordinator
        if !viewModel.isUploadFinished {
            let activityIndicatior = UIActivityIndicatorView()
            activityIndicatior.frame(forAlignmentRect: CGRect(x: 100,
                                                              y: 100,
                                                              width: 100,
                                                              height: 100))
            controller.view.addSubview(activityIndicatior)
        }
        controller.reloadData()
        return UINavigationController(rootViewController: controller)
    }

    // MARK: - Coordinator(QLPreviewControllerDataSource)

    class Coordinator: NSObject, QLPreviewControllerDataSource {

        // MARK: - Internal Properties

        let previewController: PreviewControllerTestView

        // MARK: - Lifecycle

        init(_ previewController: PreviewControllerTestView) {
            self.previewController = previewController
            super.init()
        }

        // MARK: - Internal Properties

        func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
            1
        }

        func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
            let previewItem = PreviewDocumentItem()
            previewItem.previewItemURL = self.previewController.viewModel.uploadedUrl
            return previewItem
        }
    }
}
