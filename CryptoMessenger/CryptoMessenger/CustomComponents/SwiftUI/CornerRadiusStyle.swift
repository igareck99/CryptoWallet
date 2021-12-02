import SwiftUI

// MARK: - CornerRadiusShape

struct CornerRadiusShape: Shape {

    // MARK: - Internal Properties

    var radius = CGFloat.infinity
    var corners = UIRectCorner.allCorners

    // MARK: - Internal Methods

    func path(in rect: CGRect) -> Path {
        Path(
            UIBezierPath(
                roundedRect: rect,
                byRoundingCorners: corners,
                cornerRadii: CGSize(width: radius, height: radius)
            ).cgPath
        )
    }
}

// MARK: - CornerRadiusStyle

struct CornerRadiusStyle: ViewModifier {

    // MARK: - Internal Properties

    let radius: CGFloat
    let corners: UIRectCorner

    // MARK: - Internal Methods

    func body(content: Content) -> some View {
        content
            .clipShape(CornerRadiusShape(radius: radius, corners: corners))
    }
}

// MARK: - View ()

extension View {

    // MARK: - Internal Methods

    func cornerRadius(radius: CGFloat, corners: UIRectCorner) -> some View {
        ModifiedContent(content: self, modifier: CornerRadiusStyle(radius: radius, corners: corners))
    }
}
