import SwiftUI

struct ConfirmDialogActionView: View {
	let model: ConfirmDialogActionModel

	var body: some View {
		Button {
			model.action()
		} label: {
			HStack {
				Text(model.text)
					.font(.title3Regular20)
					.foregroundColor(.chineseBlack)
				Spacer()
				Image(systemName: model.imageName)
					.resizable()
					.scaledToFit()
					.frame(width: 24, height: 24)
					.foregroundColor(.chineseBlack)
			}
		}
	}
}
