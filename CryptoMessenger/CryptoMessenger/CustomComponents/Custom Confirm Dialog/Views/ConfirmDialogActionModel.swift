import SwiftUI

// MARK: - ConfirmDialogActionModel(ViewGeneratable)

struct ConfirmDialogActionModel: ViewGeneratable {

	let id = UUID()
	let text: String
	let imageName: String
	let action: () -> Void

	// MARK: - ViewGeneratable

	@ViewBuilder
	func view() -> AnyView {
		ConfirmDialogActionView(model: self).anyView()
	}
}
