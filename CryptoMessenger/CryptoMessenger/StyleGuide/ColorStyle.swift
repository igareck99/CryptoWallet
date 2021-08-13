import SwiftUI

// MARK: - Color ()

extension Color {

    // MARK: - Lifecycle

    init(_ palette: Palette) {
        self = palette.suColor
    }
}

// MARK: - UIColor ()

extension UIColor {

    // MARK: - Lifecycle

    convenience init(_ palette: Palette) {
        self.init(cgColor: palette.cgColor)
    }
}
