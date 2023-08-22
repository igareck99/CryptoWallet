import SwiftUI

struct CustomSegmentedControll<
	SelectionValue: Hashable, Content:View
>: View {

	@Binding var selection: SelectionValue
	@Namespace var namespace
	private let content: Content

	init(
		selection: Binding<SelectionValue>,
		@ViewBuilder content: () -> Content
	) {
		self._selection = selection
		self.content = content()
	}

	var body: some View {
		HStack(spacing: 0) {
			content
		}
		.background(
			Color.clear
		)
		.frame(idealHeight: 16)
		.environment(\.selectedSegmentTag, $selection)
		.environment(\.segmentedControlNamespace, namespace)
	}
}
