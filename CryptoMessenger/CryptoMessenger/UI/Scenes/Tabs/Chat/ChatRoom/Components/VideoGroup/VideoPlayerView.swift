import SwiftUI
import AVKit

struct VideoPlayerView: UIViewControllerRepresentable {
  let player: AVPlayer?

  func updateUIViewController(_ uiViewController: AVPlayerViewController, context: Context) {
    uiViewController.player = player
  }

  func makeUIViewController(context: Context) -> AVPlayerViewController {
    let controller = AVPlayerViewController()
    controller.player = player
    return controller
  }
}
