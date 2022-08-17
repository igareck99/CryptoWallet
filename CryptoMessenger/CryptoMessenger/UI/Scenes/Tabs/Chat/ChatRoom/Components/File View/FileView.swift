import SwiftUI

struct FileView: View {


	private let isFromCurrentUser: Bool
	private let shortDate: String
	private let fileName: String
	private let url: URL?
	@Binding private var isShowFile: Bool
	private let sheetPresenting: () -> AnyView?
	private let onTapHandler: () -> Void

	init(
		isFromCurrentUser: Bool,
		shortDate: String,
		fileName: String,
		url: URL?,
		isShowFile: Binding<Bool>,
		sheetPresenting: @escaping () -> AnyView?,
		onTapHandler: @escaping () -> Void
	) {
		self.isFromCurrentUser = isFromCurrentUser
		self.shortDate = shortDate
		self.fileName = fileName
		self.url = url
		self._isShowFile = isShowFile
		self.sheetPresenting = sheetPresenting
		self.onTapHandler = onTapHandler
	}

	var body: some View {
		ZStack {
			HStack(spacing: 0) {
				if let url = url {
					PDFKitView(url: url)
						.frame(width: 80, height: 80)
						.cornerRadius(8)
						.padding(.leading, 8)
				} else {
					ShimmerView()
						.frame(width: 80, height: 80)
						.cornerRadius(8)
						.padding(.leading, 8)
				}

				VStack(spacing: 4) {
					Spacer()
					Text(fileName, [
						.color(.black()),
						.font(.medium(15)),
						.paragraph(.init(lineHeightMultiple: 1.26, alignment: .left))
					]).frame(height: 23)
					Spacer()
				}.padding(.leading, 11)

				Spacer()
			}

			CheckReadView(time: shortDate, isFromCurrentUser: isFromCurrentUser)
				.padding(.leading, isFromCurrentUser ? 0 : 130)
		}
		.frame(width: 247, height: 96)
		.sheet(isPresented: $isShowFile) {
			sheetPresenting()
		}
		.onTapGesture {
			onTapHandler()
		}
	}
}
