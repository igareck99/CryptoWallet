import SwiftUI

struct CornersRadius {
    let corners: UIRectCorner
    let radius: CGFloat
    let singleCorner: UIRectCorner
    let singleRadius: CGFloat
    
    static let left = CornersRadius(
        corners: [.topLeft, .topRight, .bottomRight],
        radius: 16.0,
        singleCorner: [.bottomLeft],
        singleRadius: 4.0
    )
    
    static let right = CornersRadius(
        corners: [.topLeft, .topRight, .bottomLeft],
        radius: 16.0,
        singleCorner: [.bottomRight],
        singleRadius: 4.0
    )
    
    static let equal = CornersRadius(
        corners: [.topLeft, .topRight],
        radius: 16.0,
        singleCorner: [.bottomRight, .bottomLeft],
        singleRadius: 16.0
    )
}
