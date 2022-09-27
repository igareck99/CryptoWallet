import SwiftUI
import Foundation

// MARK: - FileView

struct FileView: View {

    // MARK: - Private properties

    @StateObject var viewModel: FileViewModel
	private let isFromCurrentUser: Bool
	private let shortDate: String
	private let fileName: String
	private let url: URL?
	@Binding private var isShowFile: Bool
	private let sheetPresenting: () -> AnyView?
	private let onTapHandler: () -> Void

    // MARK: - Lifecycle

	init(
        viewModel: FileViewModel,
		isFromCurrentUser: Bool,
		shortDate: String,
		fileName: String,
		url: URL?,
		isShowFile: Binding<Bool>,
		sheetPresenting: @escaping () -> AnyView?,
		onTapHandler: @escaping () -> Void
	) {
        self._viewModel = StateObject(wrappedValue: viewModel)
		self.isFromCurrentUser = isFromCurrentUser
		self.shortDate = shortDate
		self.fileName = fileName
		self.url = url
		self._isShowFile = isShowFile
		self.sheetPresenting = sheetPresenting
		self.onTapHandler = onTapHandler
	}

    // MARK: - Body

	var body: some View {
		ZStack {
			HStack(spacing: 12) {
                ZStack {
                    Circle()
                        .frame(width: 44,
                               height: 44)
                        .foreground(.blue())
                    R.image.chat.clip.image
                }

                VStack(alignment: .leading, spacing: 0) {
					Text(fileName, [
						.color(.blue3E729E()),
						.font(.medium(16)),
						.paragraph(.init(lineHeightMultiple: 1.21, alignment: .left))
					]).frame(height: 23)
                    Text(viewModel.sizeOfFile, [
                        .color(.gray6589A8()),
                        .font(.medium(13)),
                        .paragraph(.init(lineHeightMultiple: 1.21, alignment: .left))
                    ]).frame(height: 23)
				}
				Spacer()
			}
            .padding(.leading, 12)
            .padding(.bottom, 8)

			CheckReadView(time: shortDate, isFromCurrentUser: isFromCurrentUser)
				.padding(.leading, isFromCurrentUser ? 0 : 130)
		}
        .frame(width: 203,
               height: 71)
		.sheet(isPresented: $isShowFile) {
			sheetPresenting()
		}
		.onTapGesture {
			onTapHandler()
		}
	}
}
