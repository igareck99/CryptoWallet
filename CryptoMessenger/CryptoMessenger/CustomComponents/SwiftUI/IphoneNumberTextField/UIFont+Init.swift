import UIKit
public typealias NativeFont = UIFont
public typealias NativeFontDescriptor = UIFontDescriptor

// MARK: - NativeFont

extension NativeFont {

    // MARK: - Lifecycle

    convenience init? (size: CGFloat = 14, weight: NativeFont.Weight = .regular,
                       design: NativeFontDescriptor.SystemDesign = .rounded) {
        if let descriptor = NativeFont.systemFont(ofSize: size, weight: weight).fontDescriptor.withDesign(design) {
            self.init(descriptor: descriptor, size: size)
        } else {
            self.init()
        }
    }
}
