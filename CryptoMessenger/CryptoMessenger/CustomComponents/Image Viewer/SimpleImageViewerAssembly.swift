import SwiftUI

enum SimpleImageViewerAssembly {
    static func build(imageUrl: URL?) -> some View {
        SimpleImageViewer(imageUrl: imageUrl)
    }
}
