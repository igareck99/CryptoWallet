import SwiftUI

struct IsVisibleKey: PreferenceKey {
    static var defaultValue: Bool = false

    static func reduce(value: inout Bool, nextValue: () -> Bool) {
        value = nextValue()
    }
}

// MARK: - ReversedScrollView

struct ReversedScrollView<Content: View>: View {
    var axis: Axis.Set
    var content: Content
    @Binding var hasReachedTop: Bool
    
    // MARK: - Lifecycle
    
    init(_ axis: Axis.Set = .vertical,
         _ hasReachedTop: Binding<Bool>,
         @ViewBuilder builder: () -> Content) {
        self.axis = axis
        self._hasReachedTop = hasReachedTop
        self.content = builder()
    }
    
    // MARK: - Body
    
    var body: some View {
        GeometryReader { contentsGeometry in
            ScrollView(axis) {
                ScrollStack(axis) {
                    GeometryReader { topViewGeometry in
                        let frame = topViewGeometry.frame(in: .global)
                        let isVisible = contentsGeometry.frame(in: .global).contains(CGPoint(x: frame.midX,
                                                                                             y: frame.midY))
                        HStack {
                            if isVisible {
                                Spacer()
                                ProgressView().progressViewStyle(CircularProgressViewStyle())
                                Spacer()
                            }
                        }
                        .preference(key: IsVisibleKey.self, value: isVisible)
                    }
                    .frame(height: 30)
                    .onPreferenceChange(IsVisibleKey.self) {
                        hasReachedTop = $0
                    }
                    Spacer()
                    content
                }
                .frame(
                    minWidth: minWidth(in: contentsGeometry, for: axis),
                    minHeight: minHeight(in: contentsGeometry, for: axis)
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
