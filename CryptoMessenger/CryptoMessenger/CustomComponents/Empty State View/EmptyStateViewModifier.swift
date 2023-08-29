import SwiftUI

enum ViewState {
	case empty
	case loading
	case content
}

struct EmptyStateViewModifier<LoadingStateView: View, EmptyStateView: View>: ViewModifier {
	var viewState: ViewState
	let emptyContent: () -> EmptyStateView
	let loadingContent: () -> LoadingStateView

	func body(content: Content) -> some View {
		switch viewState {
		case .empty:
			emptyContent()
		case .loading:
			loadingContent()
		case .content:
			content
		}
	}
}

extension View {
	func emptyState<EmptyStateView: View, LoadingStateView: View>(
		viewState: ViewState,
		emptyContent: @escaping () -> EmptyStateView,
		loadingContent: @escaping () -> LoadingStateView
	) -> some View {
		modifier(EmptyStateViewModifier(
			viewState: viewState,
			emptyContent: emptyContent,
			loadingContent: loadingContent
		))
	}
}
