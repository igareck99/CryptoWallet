import SwiftUI

enum TransactionMode: Int {
	case slow
	case medium
	case fast
}

struct TransactionSpeedSelectView: View {

	@State var mode: TransactionMode = .medium

	let onSegmentSelect: (TransactionMode) -> Void

	var body: some View {
		VStack {
			CustomSegmentedControll(selection: $mode) {

				segment("Медленно", "0.0008 ETH", .slow)
				segment("Средне", "0.00021 ETH", .medium)
				segment("Быстро", "0.00042 ETH", .fast)
			}
			.background(
				RoundedRectangle(cornerRadius: 4)
					.stroke(Color.athensGrayApprox, lineWidth: 2)
			)
			.clipShape(RoundedRectangle(cornerRadius: 4))
		}
	}

	private func segment(
		_ title: String,
		_ text: String,
		_ mode: TransactionMode
	) -> some View {
		VStack(alignment: .leading, spacing: 4) {
			texts(title, text)
		}
		.padding(.vertical, 6)
		.segmentedControlItemTag(
			tag: mode,
			onSegmentSelect: { tag in
				onSegmentSelect(tag)
			},
			backgroundView: backgroundView
		)
	}

	@ViewBuilder
	private func texts(
		_ title: String,
		_ text: String
	) -> some View {
		Text(title)
			.font(.system(size: 12, weight: .medium))
		Text(text)
			.font(.system(size: 12))
	}

	@ViewBuilder
	private func backgroundView() -> some View {
		VStack(spacing: 0) {
			RoundedRectangle(cornerRadius: 0)
				.fill(Color.azureRadianceApprox)
				.frame(height: 48)
		}
	}
}
