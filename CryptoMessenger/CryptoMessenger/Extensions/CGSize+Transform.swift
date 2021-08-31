import UIKit

// MARK: - CGSize ()

extension CGSize {

    // MARK: - Internal Methods

    func getSizeApplyingTransform(transform: CGAffineTransform) -> CGSize {
        var newSize = applying(transform)
        newSize.width = CGFloat(fabsf(Float(newSize.width)))
        newSize.height = CGFloat(fabsf(Float(newSize.height)))
        return newSize
    }
}
