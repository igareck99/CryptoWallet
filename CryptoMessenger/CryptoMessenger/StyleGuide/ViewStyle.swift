import SwiftUI
import UIKit

// MARK: - UIView ()

extension UIView {

    // MARK: - Internal Methods

    @discardableResult
    func background(_ color: UIColor?) -> Self {
        backgroundColor = color
        return self
    }

    func backgroundColor(_ color: UIColor?) -> Self {
        backgroundColor = color
        return self
    }

    @discardableResult
    func tint(_ color: UIColor) -> Self {
        tintColor = color
        return self
    }
}

extension View {

    // MARK: - Internal Methods

    func background(_ palette: Palette) -> some View {
        background(palette.suColor)
    }

    func foreground(_ color: Color) -> some View {
        foregroundColor(color)
    }

    func font(_ style: FontDecor) -> some View {
        font(style.suFont)
    }

    func addBorder<S>(_ content: S, width: CGFloat = 1, cornerRadius: CGFloat) -> some View where S : ShapeStyle {
        let roundedRect = RoundedRectangle(cornerRadius: cornerRadius)
        return clipShape(roundedRect)
            .overlay(roundedRect.strokeBorder(content, lineWidth: width))
    }
    
    func addRectangleBorder<S>(_ content: S, width: CGFloat = 1, topLeadingRadius: CGFloat,
                               bottomLeadingRadius: CGFloat, bottomTrailingRadius: CGFloat,
                               topTrailingRadius: CGFloat
    ) -> some View where S : ShapeStyle {
        let rectangle = Rectangle()
        return clipShape(rectangle)
            .cornerRadius(radius: topLeadingRadius, corners: .topLeft)
            .cornerRadius(radius: bottomLeadingRadius, corners: .bottomLeft)
            .cornerRadius(radius: bottomTrailingRadius, corners: .bottomRight)
            .cornerRadius(radius: topTrailingRadius, corners: .topRight)
            .overlay(rectangle.strokeBorder(content, lineWidth: width))
    }
}
