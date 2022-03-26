import SwiftUI

// MARK: - CameraFrameView

struct CameraFrameView: View {

    // MARK: - Internal Properties

    var image: CGImage?

    // MARK: - Body

    var body: some View {
        if let image = image {
            GeometryReader { geometry in
                Image(decorative: image, scale: 1.0, orientation: .upMirrored)
                    .resizable()
                    .scaledToFill()
                    .frame(
                        width: geometry.size.width,
                        height: geometry.size.height,
                        alignment: .center)
                    .clipped()
            }
        } else {
            EmptyView()
        }
    }
}
