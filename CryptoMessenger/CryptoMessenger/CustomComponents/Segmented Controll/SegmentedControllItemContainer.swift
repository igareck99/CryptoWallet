import SwiftUI

struct SegmentedControllItemContainer<
	SelectionValue: Hashable, Content: View, BackgroundView: View
>: View {

	@Environment(\.selectedSegmentTag) var selectedSegmentTag
	@Environment(\.segmentedControlNamespace) var segmentedControlNamespace
	@Namespace var namespace
	let tag: SelectionValue
	let content: Content
	let onSegmentSelect: (SelectionValue) -> Void
	let backgroundView: () -> BackgroundView

	@ViewBuilder var body: some View {
		content
			.frame(maxWidth: .infinity)
		//			.contentShape(Rectangle())
			.foregroundColor(isSelected ? .white.opacity(0.8) : .black)
			.background(isSelected ? background : nil)
			.onTapGesture {
				select()
			}
			.disabled(isSelected)
	}

	private var background: some View {
		backgroundView()
			.matchedGeometryEffect(
				id: "selection",
				in: segmentedControlNamespace ?? namespace
			)
	}

	var isSelected: Bool {
		let selectedTag = (selectedSegmentTag as? Binding<SelectionValue>)?.wrappedValue
		return tag == selectedTag
	}

	private func select() {
		guard let binding = selectedSegmentTag as? Binding<SelectionValue> else { return }
		onSegmentSelect(tag)
		withAnimation(.easeInOut(duration: 0.2)) {
			binding.wrappedValue = tag
		}
	}
}
