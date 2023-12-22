import SwiftUI

// MARK: - ReversedScrollView

struct ReversedScrollView<Content: View>: View {
    var axis: Axis.Set
    var content: Content
    
    // MARK: - Lifecycle
    
    init(_ axis: Axis.Set = .vertical, @ViewBuilder builder: () -> Content) {
        self.axis = axis
        self.content = builder()
    }
    
    // MARK: - Body
    
    var body: some View {
        GeometryReader { proxy in
            ScrollView(axis) {
                ScrollStack(axis) {
                    Spacer()
                    content
                }
                .frame(
                    minWidth: minWidth(in: proxy, for: axis),
                    minHeight: minHeight(in: proxy, for: axis)
                )
            }
        }
    }
    
    // MARK: - Private Methods
    
    private func minWidth(in proxy: GeometryProxy, for axis: Axis.Set) -> CGFloat? {
       axis.contains(.horizontal) ? proxy.size.width : nil
    }
        
    private func minHeight(in proxy: GeometryProxy, for axis: Axis.Set) -> CGFloat? {
       axis.contains(.vertical) ? proxy.size.height : nil
    }
}
