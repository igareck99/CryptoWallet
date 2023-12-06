import CoreImage.CIFilterBuiltins
import SwiftUI

protocol QRCodeServiceProtocol {
    func generateQRCode(string: String) -> Image?
}

final class QRCodeService {
    private let context = CIContext()
    private let filter = CIFilter.qrCodeGenerator()
}

// MARK: - QRCodeServiceProtocol

extension QRCodeService: QRCodeServiceProtocol {
    func generateQRCode(string: String) -> Image? {
        filter.message = Data(string.utf8)
        guard let outputImage = filter.outputImage,
              let image = context.createCGImage(outputImage, from: outputImage.extent) else {
            return nil
        }
        return Image(uiImage: UIImage(cgImage: image)).interpolation(.none)
    }
}
