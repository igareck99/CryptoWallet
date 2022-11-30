import SwiftUI

// MARK: - ReactionsGrid

struct ReactionsGrid<ViewModel: ReactionsGroupViewModelProtocol>: View {

    // MARK: - Internal Properties

	@Binding var totalHeight: CGFloat
	@ObservedObject var viewModel: ViewModel

	var body: some View {
		VStack(spacing: 0) {
			GeometryReader { gReader in
				generateContent(in: gReader)
			}
		}
		.frame(maxHeight: totalHeight)
	}

    // MARK: - Private Methods

	private func generateContent(in gReader: GeometryProxy) -> some View {
		var width = CGFloat.zero
		var height = CGFloat.zero

		return ZStack(alignment: .topLeading) {
			ForEach(viewModel.items, id: \.id) { item in
				item.view()
					.padding(.vertical, 4)
                    .padding(.leading, 4)
					.alignmentGuide(.leading, computeValue: { d in
                        if abs(width - item.getItemWidth()) > gReader.size.width - 14 {
							width = 0
							height -= d.height
						}
						let result = width
						if item == viewModel.items.last {
							width = 0 // last item
						} else {
							width -= d.width
						}
						return result
					})
					.alignmentGuide(.top, computeValue: { _ in
						let result = height
						if item == viewModel.items.last {
							height = 0 // last item
						}
						return result
					})
			}
		}
		.background(viewHeightReader())
	}

	private func viewHeightReader() -> some View {
		return GeometryReader { geometry -> Color in
			let rect = geometry.frame(in: .local)
			DispatchQueue.main.async {
				debugPrint("rect.size.height: \(rect.size.height)")
				totalHeight = rect.size.height
			}
			return .clear
		}
	}
}

func viewHeightNew(for width: CGFloat, reactionItems: [ReactionTextsItem]) -> CGFloat {
    guard !reactionItems.isEmpty else { return 0 }
    var countSize = reactionItems.reduce(CGFloat(0)) {
        $0 + $1.texts[0].width
    }
    countSize = width - countSize
    if countSize > 0 {
        return 38
    }
    return 70
}
