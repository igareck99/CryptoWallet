import SwiftUI

struct ReactionsGrid<ViewModel: ReactionsGroupViewModelProtocol>: View {

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

	private func generateContent(in gReader: GeometryProxy) -> some View {
		var width = CGFloat.zero
		var height = CGFloat.zero

		return ZStack(alignment: .topLeading) {
			ForEach(viewModel.items, id: \.id) { item in
				item.view()
					.padding([.horizontal, .vertical], 4)
					.alignmentGuide(.leading, computeValue: { d in
						if abs(width - d.width) > gReader.size.width {
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

func precalculateViewHeight(for width: CGFloat, itemsCount: Int) -> CGFloat {

	guard itemsCount > 0 else { return 0 }

	let countSize = width - CGFloat(itemsCount * 56)
	if countSize > 0 {
		return 38
	}
	return 70
}
