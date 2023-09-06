import AVKit
import SwiftUI

enum VideoPlayerViewAssembly {
    static func build(url: URL) -> some View {
        let player = AVPlayer(url: url)
        let view = VideoPlayerView(player: player)
        return view
    }
}
