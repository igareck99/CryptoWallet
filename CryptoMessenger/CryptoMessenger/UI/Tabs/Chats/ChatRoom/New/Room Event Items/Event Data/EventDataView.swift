import SwiftUI

// MARK: - EventDataView

struct EventDataView<ReadData: View>: View {
    let model: EventData
    let readData: ReadData
    var body: some View {
        HStack(spacing: .zero) {
            Spacer()
            HStack(spacing: 4) {
                Text(model.date)
                    .font(.system(size: 12, weight: .regular))
                    .foregroundColor(model.dateColor)
                if model.isFromCurrentUser {
                    readData
                }
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 2)
            .background(model.backColor)
            .clipShape(
                RoundedRectangle(cornerRadius: 30)
            )
        }
    }
}
