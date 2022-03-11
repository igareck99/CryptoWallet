import SwiftUI

struct CameraFrameView: View {

    var image: CGImage?

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
