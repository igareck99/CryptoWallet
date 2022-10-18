import SwiftUI
import AVKit

// MARK: - VideoPlayerView(UIViewControllerRepresentable)

struct VideoPlayerView: UIViewControllerRepresentable {

    // MARK: - Internal Properties

    let player: AVPlayer?

    // MARK: - Internal Properties

    func updateUIViewController(_ uiViewController: AVPlayerViewController, context: Context) {
        uiViewController.player = player
    }

    func makeUIViewController(context: Context) -> AVPlayerViewController {
        let controller = AVPlayerViewController()
        controller.player = player
        return controller
    }
}
