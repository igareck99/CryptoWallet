import SwiftUI

struct Snackbar: View {
	let color: Color
	let text: String

	init(
		text: String,
		color: Color = .red
	) {
		self.text = text
		self.color = color
	}

	var body: some View {
		VStack(alignment: .leading) {
			Text(text)
				.font(.system(size: 15))
				.foregroundColor(.white)
				.padding()
				.frame(maxWidth: .infinity, alignment: .leading)
		}
		.frame(maxWidth: .infinity, idealHeight: 48)
		.background(color)
		.cornerRadius(8)
		.padding(.horizontal, 16)
		.padding(.bottom)
	}
}
