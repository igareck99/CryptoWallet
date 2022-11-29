import SwiftUI

struct EmptyStateViewModifier<EmptyContent: View>: ViewModifier {
	var isEmpty: Bool
	let emptyContent: () -> EmptyContent

	func body(content: Content) -> some View {
		if isEmpty {
			emptyContent()
		} else {
			content
		}
	}
}

extension View {
	func emptyState<EmptyContent>(
		_ isEmpty: Bool,
		emptyContent: @escaping () -> EmptyContent
	) -> some View where EmptyContent: View {
		modifier(EmptyStateViewModifier(isEmpty: isEmpty, emptyContent: emptyContent))
	}
}
