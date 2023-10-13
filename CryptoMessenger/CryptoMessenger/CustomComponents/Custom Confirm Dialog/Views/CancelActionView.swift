import SwiftUI

struct CancelActionView: View {
	let model: CancelActionViewModel

	var body: some View {
		Button {
			model.action()
		} label: {
			HStack {
				Text(model.text)
					.font(.title3Regular20)
					.foregroundColor(.chineseBlack)
			}
		}
	}
}
