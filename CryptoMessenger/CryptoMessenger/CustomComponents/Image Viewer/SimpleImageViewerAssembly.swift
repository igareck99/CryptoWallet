import SwiftUI

enum SimpleImageViewerAssembly {
    static func build(image: Image) -> some View {
        SimpleImageViewer(image: image)
    }
}
