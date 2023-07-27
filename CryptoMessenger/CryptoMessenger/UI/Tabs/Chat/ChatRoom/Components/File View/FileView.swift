import Foundation
import SwiftUI

// swiftlint:disable all

// MARK: - FileView

struct FileView: View {

    // MARK: - Private properties

    @StateObject var viewModel: FileViewModel
	private let isFromCurrentUser: Bool
	private let shortDate: String
	private let fileName: String
	private let url: URL?
	@Binding private var isShowFile: Bool
	private let sheetPresenting: (URL?) -> Void
	private let reactionItems: [ReactionTextsItem]

	@State private var totalHeight: CGFloat = .zero

    // MARK: - Lifecycle

	init(
        viewModel: FileViewModel,
		isFromCurrentUser: Bool,
		shortDate: String,
		fileName: String,
		url: URL?,
		isShowFile: Binding<Bool>,
		reactionItems: [ReactionTextsItem],
		sheetPresenting: @escaping (URL?) -> Void
	) {
        self._viewModel = StateObject(wrappedValue: viewModel)
		self.isFromCurrentUser = isFromCurrentUser
		self.shortDate = shortDate
		self.fileName = fileName
		self.url = url
		self._isShowFile = isShowFile
		self.reactionItems = reactionItems
		self.sheetPresenting = sheetPresenting
	}

    // MARK: - Body

	var body: some View {
		VStack(alignment: .leading, spacing: 0) {
			HStack(alignment: .top, spacing: 12) {
				ZStack {
					Circle()
						.frame(width: 44, height: 44)
						.foregroundColor(.dodgerTransBlue)
					R.image.chat.clip.image
				}

				VStack(alignment: .leading, spacing: 0) {
					Text(fileName, [
						.paragraph(.init(lineHeightMultiple: 1.21, alignment: .left))
					])
                    .foregroundColor(.dodgerBlue)
                    .font(.system(size: 16, weight: .medium))
					.frame(height: 23)
					Text(viewModel.sizeOfFile, [
						.paragraph(.init(lineHeightMultiple: 1.21, alignment: .left))
					])
                    .foregroundColor(.ashGray)
                    .font(.system(size: 13, weight: .medium))
					.frame(height: 23)
				}
			}
			.padding(.top, 8)
			.padding([.leading, .trailing], 12)

			VStack(alignment: .leading, spacing: 0) {
				ReactionsGrid(
					totalHeight: $totalHeight,
                    viewModel: ReactionsGroupViewModel(items: reactionItems)
				)
			}
            .frame(minHeight: totalHeight == 0 ? viewHeightNew(for: 220, reactionItems: reactionItems) : totalHeight)
			.padding([.leading, .trailing], 8)
			.padding(.bottom, 4)

			VStack(alignment: .trailing, spacing: 0) {
				CheckReadView(time: shortDate, isFromCurrentUser: isFromCurrentUser)
			}
			.frame(height: 14)
			.padding(.bottom, 6)
		}
		.padding(.all, 0)
		.frame(width: 220)
		.fixedSize(horizontal: true, vertical: false)
		.onTapGesture {
			isShowFile = true
            sheetPresenting(url)
		}
	}
}
