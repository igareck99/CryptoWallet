import SwiftUI

// MARK: - ShareTextView (UIViewControllerRepresentable)

struct ShareTextView: UIViewControllerRepresentable {

    // MARK: - Internal Properties

    var text: String

    // MARK: - Internal Methods

    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(activityItems: [text],
                                                  applicationActivities: nil)
        return controller
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {
    }
}
