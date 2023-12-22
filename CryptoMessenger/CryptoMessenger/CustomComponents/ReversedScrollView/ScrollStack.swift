import SwiftUI

// MARK: - ScrollStack

struct ScrollStack<Content: View>: View {
    var axis: Axis.Set
    var content: Content

    // MARK: - Lifecycle

    init(_ axis: Axis.Set = .vertical, @ViewBuilder builder: () -> Content) {
        self.axis = axis
        self.content = builder()
    }

    // MARK: - Body

    var body: some View {
        switch axis {
        case .horizontal:
            HStack {
                content
            }
        case .vertical:
            VStack {
                content
            }
        default:
            VStack {
                content
            }
        }
    }
}
