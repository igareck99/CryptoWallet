import SwiftUI

// MARK: - Snackbar

struct Snackbar: View {

    // MARK: - Internal Properties

	let color: Color
	let text: String

    // MARK: - Lifecycle

	init(
		text: String,
		color: Color = .red
	) {
		self.text = text
		self.color = color
	}

    // MARK: - Body

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
