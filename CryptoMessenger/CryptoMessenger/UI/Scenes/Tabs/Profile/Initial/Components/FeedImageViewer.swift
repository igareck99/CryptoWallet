import SwiftUI

// MARK: - FeedShareSheet (UIViewControllerRepresentable)

struct FeedShareSheet: UIViewControllerRepresentable {

    // MARK: - Internal Properties

    var image: UIImage?

    // MARK: - Internal Methods

    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(activityItems: [image],
                                                  applicationActivities: nil)
        return controller
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {
    }
}
