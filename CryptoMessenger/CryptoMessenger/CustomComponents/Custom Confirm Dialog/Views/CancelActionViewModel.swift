import SwiftUI

struct CancelActionViewModel: ViewGeneratable {
	let id = UUID()
	let text: String
	let action: () -> Void

	// MARK: - ViewGeneratable

	@ViewBuilder
	func view() -> AnyView {
		CancelActionView(model: self).anyView()
	}
}
