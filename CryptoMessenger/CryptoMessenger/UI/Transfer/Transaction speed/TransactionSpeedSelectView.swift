import SwiftUI

enum TransactionMode: Int {
	case slow
	case medium
	case fast
}

struct TransactionSpeedSelectView: View {

	@State var mode: TransactionMode = .medium

	let transactionFees: [TransactionSpeed]
	let onSegmentSelect: (TransactionMode) -> Void

	var body: some View {
		VStack {
			CustomSegmentedControll(selection: $mode) {
				ForEach(transactionFees) { fee in
					segment(fee.title, fee.feeText, fee.mode)
				}
			}
			.background(
				RoundedRectangle(cornerRadius: 4)
                    .stroke(Color.gainsboro, lineWidth: 2)
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
            texts(title, text, mode == self.mode)
				.padding(.horizontal, 4)
		}
		.padding(.vertical, 4)
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
        _ text: String,
        _ isSelected: Bool
    ) -> some View {
        Text(title)
            .font(.caption1Medium12)
            .lineLimit(1)
            .foreground(isSelected ? .white : .chineseBlack)
			.truncationMode(.middle)
		Text(text)
			.font(.caption1Regular12)
            .foregroundColor(isSelected ? .white : .ashGray)
			.lineLimit(1)
			.truncationMode(.middle)
	}

	@ViewBuilder
	private func backgroundView() -> some View {
		VStack(spacing: 0) {
			RoundedRectangle(cornerRadius: 0)
				.fill(Color.dodgerBlue)
				.frame(height: 48)
		}
	}
}
