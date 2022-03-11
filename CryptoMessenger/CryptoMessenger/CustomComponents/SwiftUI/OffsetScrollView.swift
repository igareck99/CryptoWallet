import SwiftUI

// MARK: - ScrollOffsetPreferenceKey

private struct ScrollOffsetPreferenceKey: PreferenceKey {

    // MARK: - Internal Properties

    static var defaultValue: CGPoint = .zero

    // MARK: - Internal Methods

    static func reduce(value: inout CGPoint, nextValue: () -> CGPoint) {}
}

// MARK: - OffsetScrollView

struct OffsetScrollView<Content: View>: View {

    // MARK: - Private Properties

    private let axes: Axis.Set
    private let showsIndicators: Bool
    private let offsetChanged: (CGPoint) -> Void
    private let content: Content
    private let coordinateSpace = "offsetScrollView"

    // MARK: - Life Cycle

    init(
        _ axes: Axis.Set = .horizontal,
        showsIndicators: Bool = false,
        offsetChanged: @escaping (CGPoint) -> Void = { _ in },
        @ViewBuilder content: () -> Content
    ) {
        self.axes = axes
        self.showsIndicators = showsIndicators
        self.offsetChanged = offsetChanged
        self.content = content()
    }

    // MARK: - Body

    var body: some View {
        ScrollView(axes, showsIndicators: showsIndicators) {
            GeometryReader { geometry in
                Color.clear
                .preference(
                    key: ScrollOffsetPreferenceKey.self,
                    value: geometry.frame(in: .named(coordinateSpace)).origin
                )
            }
            .frame(width: 0, height: 0)

            content
        }
        .coordinateSpace(name: coordinateSpace)
        .onPreferenceChange(ScrollOffsetPreferenceKey.self, perform: offsetChanged)
    }
}
