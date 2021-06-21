import UIKit

// MARK: UIImage ()

extension UIImage {

    // MARK: - Internal Methods

    func resizeImage(for size: CGSize) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { _ in
            draw(in: CGRect(origin: .zero, size: size))
        }
    }
}
