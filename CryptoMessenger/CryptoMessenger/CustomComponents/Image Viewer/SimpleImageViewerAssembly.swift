import SwiftUI

enum SimpleImageViewerAssembly {
    static func build(image: Image?, url: URL?) -> some View {
        SimpleImageViewer(imageUrl: url, image: image)
    }
}
