import SwiftUI

// MARK: - UIImage ()

extension UIImage {

    // MARK: - Lifecycle

    convenience init?(_ color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(rect.size, true, 0.0)
        color.setFill()
        UIRectFill(rect)

        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        guard let cgImage = image?.cgImage else { return nil }
        self.init(cgImage: cgImage)
    }

    // MARK: - Internal Properties

    var averageColor: UIColor? {
        guard let inputImage = CIImage(image: self) else { return nil }

        let extentVector = CIVector(
            x: inputImage.extent.origin.x,
            y: inputImage.extent.origin.y,
            z: inputImage.extent.size.width,
            w: inputImage.extent.size.height
        )

        // "CIAreaAverage" returns a single-pixel image that contains the average color for the region of interest.
        guard let filter = CIFilter(
            name: "CIAreaAverage",
            parameters: [kCIInputImageKey: inputImage, kCIInputExtentKey: extentVector]
        ) else { return nil }
        guard let outputImage = filter.outputImage else { return nil }

        var bitmap = [UInt8](repeating: 0, count: 4)
        let context = CIContext(options: [.workingColorSpace: kCFNull!])

        context.render(
            outputImage,
            toBitmap: &bitmap,
            rowBytes: 4,
            bounds: CGRect(x: 0, y: 0, width: 1, height: 1),
            format: .RGBA8,
            colorSpace: nil
        )

        return UIColor(
            red: CGFloat(bitmap[0]) / 255,
            green: CGFloat(bitmap[1]) / 255,
            blue: CGFloat(bitmap[2]) / 255,
            alpha: CGFloat(bitmap[3]) / 255
        )
    }

    // MARK: - Internal Methods
    func resized(to size: CGSize) -> UIImage {
        return UIGraphicsImageRenderer(size: size).image { _ in
            draw(in: CGRect(origin: .zero, size: size))
        }
    }

    func resizeImage(for size: CGSize) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { _ in
            draw(in: CGRect(origin: .zero, size: size))
        }
    }

    func fixOrientation() -> UIImage {
        guard imageOrientation != .up else { return self }

        let imageOrientation = imageOrientation

        var transform: CGAffineTransform = .identity

        switch imageOrientation {
        case .down, .downMirrored:
            transform = transform.translatedBy(x: size.width, y: size.height)
            transform = transform.rotated(by: .pi)
        case .left, .leftMirrored:
            transform = transform.translatedBy(x: size.width, y: 0)
            transform = transform.rotated(by: .pi * 0.5)
        case .right, .rightMirrored:
            transform = transform.translatedBy(x: 0, y: size.height)
            transform = transform.rotated(by: .pi * -0.5)
        case .up, .upMirrored:
            break
        default:
            break
        }

        switch imageOrientation {
        case .upMirrored, .downMirrored:
            transform = transform.translatedBy(x: size.width, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
        case .leftMirrored, .rightMirrored:
            transform = transform.translatedBy(x: size.height, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
        case .up, .down, .left, .right:
            break
        default:
            break
        }

        guard var cgImage = cgImage else { return self }

        autoreleasepool {
            var context: CGContext?

            guard
                let colorSpace = cgImage.colorSpace,
                let cnxt = CGContext(
                    data: nil,
                    width: Int(size.width),
                    height: Int(size.height),
                    bitsPerComponent: cgImage.bitsPerComponent,
                    bytesPerRow: 0,
                    space: colorSpace,
                    bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue
                )
            else {
                return
            }
            context = cnxt

            context?.concatenate(transform)

            var drawRect: CGRect = .zero
            switch imageOrientation {
            case .left, .leftMirrored, .right, .rightMirrored:
                drawRect.size = CGSize(width: size.height, height: size.width)
            default:
                drawRect.size = CGSize(width: size.width, height: size.height)
            }

            context?.draw(cgImage, in: drawRect)

            guard let newCGImage = context?.makeImage() else { return }

            cgImage = newCGImage
        }

        return UIImage(cgImage: cgImage, scale: 1, orientation: .up)
    }

    func scaled(toWidth width: CGFloat) -> UIImage? {
        let oldWidth = size.width
        let scaleFactor = width / oldWidth
        let newHeight = size.height * scaleFactor
        let newWidth = oldWidth * scaleFactor
        let newSize = CGSize(width: newWidth, height: newHeight)
        let renderer = UIGraphicsImageRenderer(size: newSize)
        let newImage = renderer.image { _ in
            self.draw(in: CGRect(origin: .zero, size: newSize))
        }
        return newImage
    }

    func scaled(toHeight height: CGFloat) -> UIImage? {
        let scale = height / size.height
        let newWidth = size.width * scale
        let newSize = CGSize(width: newWidth, height: height)
        let renderer = UIGraphicsImageRenderer(size: newSize)
        let newImage = renderer.image { _ in
            self.draw(in: CGRect(origin: .zero, size: newSize))
        }

        return newImage
    }

    func crop(width: Double, height: Double) -> UIImage {
        guard let cgImage = self.cgImage else { return self }
        let contextImage = UIImage(cgImage: cgImage)

        let contextSize = contextImage.size

        var posX = CGFloat(0)
        var posY = CGFloat(0)
        var cgwidth = CGFloat(width)
        var cgheight = CGFloat(height)

        if contextSize.width > contextSize.height {
            posX = ((contextSize.width - contextSize.height) / 2)
            posY = 0
            cgwidth = contextSize.height
            cgheight = contextSize.height
        } else {
            posX = 0
            posY = ((contextSize.height - contextSize.width) / 2)
            cgwidth = contextSize.width
            cgheight = contextSize.width
        }

        let rect = CGRect(x: posX, y: posY, width: cgwidth, height: cgheight)

        guard let contextImageCGImage = contextImage.cgImage,
              let imageRef = contextImageCGImage.cropping(to: rect) else { return self }

        let image = UIImage(cgImage: imageRef, scale: self.scale, orientation: self.imageOrientation)

        return image
    }
    
    func scaleToFit(in size: CGSize) -> UIImage? {
        var ratio = max(size.width / self.size.width, size.height / self.size.height)
        if ratio >= 1.0 {
            return self
        }
        
        ratio = ceil(ratio * 100) / 100
        
        let newSize = CGSize(width: self.size.width * ratio, height: self.size.height * ratio)
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        UIGraphicsBeginImageContextWithOptions(newSize, true, 1.0)
        draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }

	static func biometryImage(type: AvailableBiometric) -> UIImage? {
		switch type {
		case .faceID:
			return R.image.pinCode.faceId()
		case .touchID:
			return R.image.pinCode.touchId()
		default:
			return nil
		}
	}
}

extension UIImage {
    static func imageFrom(color: UIColor, size: CGSize = .init(width: 1, height: 1)) -> UIImage {
        let image = UIGraphicsImageRenderer(size: size).image { rendererContext in
            color.setFill()
            rendererContext.fill(CGRect(origin: .zero, size: size))
        }
        return image
    }
}

extension UIImage {
    // MARK: - JPEGQuality

    enum JPEGQuality: CGFloat {

        // MARK: - Types

        case lowest = 0
        case low = 0.25
        case medium = 0.5
        case high = 0.75
        case highest = 1
    }

    // MARK: - Internal Methods

    func jpeg(_ jpegQuality: JPEGQuality) -> Data? {
        jpegData(compressionQuality: jpegQuality.rawValue)
    }
}
