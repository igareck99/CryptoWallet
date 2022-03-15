import SwiftUI

// MARK: - TrackableScrollOffsetPreferenceKey (PreferenceKey)

private struct TrackableScrollOffsetPreferenceKey: PreferenceKey {

    // MARK: - Type

    typealias Value = [CGFloat]

    // MARK: - Static Properties

    static var defaultValue: [CGFloat] = [0]

    // MARK: - Static Methods

    static func reduce(value: inout [CGFloat], nextValue: () -> [CGFloat]) {
        value.append(contentsOf: nextValue())
    }
}

// MARK: - TrackableScrollView

struct TrackableScrollView<Content>: View where Content: View {

    // MARK: - Internal Properties

    let axes: Axis.Set
    let showIndicators: Bool
    let offsetChanged: (CGFloat) -> Void
    let content: Content

    // MARK: - Life Cycle

    init(
        axes: Axis.Set = .vertical,
        showIndicators: Bool = false,
        offsetChanged: @escaping (CGFloat) -> Void = { _ in },
        @ViewBuilder content: () -> Content
    ) {
        self.axes = axes
        self.showIndicators = showIndicators
        self.offsetChanged = offsetChanged
        self.content = content()
    }

    // MARK: - Body

    var body: some View {
        GeometryReader { outsideProxy in
            ScrollView(axes, showsIndicators: showIndicators) {
                ZStack(alignment: axes == .vertical ? .top : .leading) {
                    GeometryReader { insideProxy in
                        Color.clear.preference(
                            key: TrackableScrollOffsetPreferenceKey.self,
                            value: [calculateOffset(outsideProxy: outsideProxy, insideProxy: insideProxy)]
                        )
                    }
                    VStack {
                        content
                    }
                }
            }
            .onPreferenceChange(TrackableScrollOffsetPreferenceKey.self) { value in
                offsetChanged(value[0])
            }
        }
    }

    // MARK: - Private Methods

    private func calculateOffset(outsideProxy: GeometryProxy, insideProxy: GeometryProxy) -> CGFloat {
        if axes == .vertical {
            return outsideProxy.frame(in: .global).minY - insideProxy.frame(in: .global).minY
        } else {
            return outsideProxy.frame(in: .global).minX - insideProxy.frame(in: .global).minX
        }
    }
}
