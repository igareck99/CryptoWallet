import SwiftUI

extension View {
	func placeholder(
		_ text: String,
		when shouldShow: Bool,
		alignment: Alignment = .leading
	) -> some View {
		placeholder(when: shouldShow, alignment: alignment) { Text(text).foregroundColor(.gray) }
	}

	func placeholder<Content: View>(
		when shouldShow: Bool,
		alignment: Alignment = .leading,
		@ViewBuilder placeholder: () -> Content
	) -> some View {
		ZStack(alignment: alignment) {
			placeholder().opacity(shouldShow ? 1 : 0)
			self
		}
	}

	func segmentedControlItemTag<
		SelectionValue: Hashable,
		Background: View
	>(
		tag: SelectionValue,
		onSegmentSelect: @escaping (SelectionValue) -> Void,
		@ViewBuilder backgroundView: @escaping () -> Background
	) -> some View {
		return SegmentedControllItemContainer(
			tag: tag,
			content: self,
			onSegmentSelect: onSegmentSelect,
			backgroundView: backgroundView
		)
	}
}

extension View {
	func anyView() -> AnyView {
		AnyView(self)
	}
}

extension View {
    func pinchToZoom() -> some View {
        self.modifier(PinchToZoom())
    }
}
