import SwiftUI

struct ChatSystemEventView: View {

	private let text: String
	private let backColor: Color
	private let cornerRadius: CGFloat

	init(
		text: String,
		backColor: Color = Color(red: 242 / 255, green: 160 / 255, blue: 76 / 255),
		cornerRadius: CGFloat = 8
	) {
		self.text = text
		self.backColor = backColor
		self.cornerRadius = cornerRadius
	}

	var body: some View {
		HStack {
			Text(text)
				.font(.regular(14))
				.padding(.horizontal, 17)
				.padding(.vertical, 3)
				.foregroundColor(.white)
		}
		.background(backColor)
		.cornerRadius(cornerRadius)
		.padding(.vertical, 8)
	}
}
