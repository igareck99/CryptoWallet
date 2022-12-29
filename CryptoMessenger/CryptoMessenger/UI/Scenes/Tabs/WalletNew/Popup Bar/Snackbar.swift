import SwiftUI

struct Snackbar: View {
	var body: some View {
		VStack(alignment: .leading) {
			Text("Ошибка отправки транзакции")
				.font(.system(size: 15))
				.foregroundColor(.white)
				.padding()
				.frame(maxWidth: .infinity, alignment: .leading)
		}
		.frame(maxWidth: .infinity, idealHeight: 48)
		.background(Color.red)
		.cornerRadius(8)
		.padding(.horizontal, 16)
		.padding(.bottom)
	}
}
