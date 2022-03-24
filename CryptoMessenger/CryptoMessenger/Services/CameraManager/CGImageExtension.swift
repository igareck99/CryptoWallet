import CoreGraphics
import VideoToolbox

// MARK: - CGImage ()

extension CGImage {

    // MARK: - Static Methods

    static func create(from cvPixelBuffer: CVPixelBuffer?) -> CGImage? {
        guard let pixelBuffer = cvPixelBuffer else { return nil }
        var image: CGImage?
        VTCreateCGImageFromCVPixelBuffer(
            pixelBuffer,
            options: nil,
            imageOut: &image
        )
        return image
    }
}
