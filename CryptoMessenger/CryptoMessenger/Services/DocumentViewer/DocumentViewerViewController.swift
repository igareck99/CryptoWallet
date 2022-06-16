import UIKit
import QuickLook

// MARK: - DocumentViewerViewController

final class DocumentViewerViewController: UIViewController {

    // MARK: - Internal Properties

    let previewController = QLPreviewController()
    var previewItems: [PreviewDocumentItem] = []
    let restManager = DocumentViewerRestManager()
    var url: URL

    // MARK: - Lifecycle

    init(with url: URL) {
        self.url = url
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        quickLook(url: url)
    }

    // MARK: - Internal Methods

    func quickLook(url: URL) {
        restManager.quickLook(url: url, completion: { fileUrl in
            guard var unwrappedFileUrl = fileUrl else {
                self.presentAlertController(with: R.string.localizable.documentViewerUploadError())
                return
            }
            unwrappedFileUrl.hasHiddenExtension = true
            let previewItem = PreviewDocumentItem()
            previewItem.previewItemURL = unwrappedFileUrl
            self.previewItems.append(previewItem)
            DispatchQueue.main.async {
                self.previewController.delegate = self
                self.previewController.dataSource = self
                self.previewController.currentPreviewItemIndex = 0
                self.present(self.previewController, animated: true)
             }
        })
    }

    func presentAlertController(with message: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
            alert.addAction(.init(title: "OK", style: .default))
            self.present(alert, animated: true)
        }
    }
}

// MARK: - DocumentViewerViewController(QLPreviewControllerDelegate)

extension DocumentViewerViewController: QLPreviewControllerDelegate, QLPreviewControllerDataSource {

    func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
        previewItems.count
    }

    func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
        previewItems[index]
    }
}

// MARK: - PreviewDocumentItem(QLPreviewItem)

class PreviewDocumentItem: NSObject, QLPreviewItem {
    var previewItemURL: URL?
}
