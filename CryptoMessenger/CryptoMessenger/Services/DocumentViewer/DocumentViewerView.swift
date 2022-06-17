import UIKit
import SwiftUI

// MARK: - DocumentViewerView(UIViewControllerRepresentable)

struct DocumentViewerView: UIViewControllerRepresentable {

    var url: URL

    // MARK: - Internal Methods

    func makeUIViewController(context: Context) -> DocumentViewerViewController {
        return DocumentViewerViewController(with: url)
    }

    func updateUIViewController(_ uiViewController: DocumentViewerViewController,
                                context: Context) {
    }
}
