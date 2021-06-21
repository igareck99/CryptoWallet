import SwiftUI

// MARK: View ()

extension View {
    var uiView: UIView { UIHostingController(rootView: self).view }
}
