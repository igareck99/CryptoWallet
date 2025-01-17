import SwiftUI

struct TrackableScroll<Content>: View where Content: View {
	let axes: Axis.Set
	let showIndicators: Bool
	@Binding var contentOffset: CGFloat
	let content: Content

	init(
		_ axes: Axis.Set = .vertical,
		showIndicators: Bool = true,
		contentOffset: Binding<CGFloat>,
		@ViewBuilder content: () -> Content
	) {
		self.axes = axes
		self.showIndicators = showIndicators
		self._contentOffset = contentOffset
		self.content = content()
	}

	var body: some View {
		GeometryReader { outsideProxy in
			ScrollView(self.axes, showsIndicators: self.showIndicators) {
				ZStack(alignment: self.axes == .vertical ? .top : .leading) {
					GeometryReader { insideProxy in
						Color.clear
							.preference(
								key: ScrollOffsetPreferenceKey.self,
								value: [self.calculateContentOffset(fromOutsideProxy: outsideProxy, insideProxy: insideProxy)]
							)
					}
					VStack {
						self.content
					}
				}
			}
			.onPreferenceChange(ScrollOffsetPreferenceKey.self) { value in
				self.contentOffset = value[0]
			}
		}
	}

	private func calculateContentOffset(
		fromOutsideProxy outsideProxy: GeometryProxy,
		insideProxy: GeometryProxy
	) -> CGFloat {
		if axes == .vertical {
			return outsideProxy.frame(in: .global).minY - insideProxy.frame(in: .global).minY
		} else {
			return outsideProxy.frame(in: .global).minX - insideProxy.frame(in: .global).minX
		}
	}
}

struct ScrollOffsetPreferenceKey: PreferenceKey {
	typealias Value = [CGFloat]

	static var defaultValue: [CGFloat] = [0]

	static func reduce(value: inout [CGFloat], nextValue: () -> [CGFloat]) {
		value.append(contentsOf: nextValue())
	}
}


struct ScrollViewOffsetPreferenceKey: PreferenceKey {
  static var defaultValue = CGFloat.zero

  static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
    value += nextValue()
  }
}
