import SwiftUI

struct EventDataView<ReadData: View>: View {
    let model: EventData
    let readData: ReadData
    var body: some View {
        HStack(spacing: .zero) {
            Spacer()
            HStack(spacing: 4) {
                Text(model.date)
                    .font(.caption2Regular11)
                    .foregroundColor(model.dateColor)
                    .padding(.leading, 4)
                if model.isFromCurrentUser {
                    readData
                        .padding(.trailing, 4)
                }
            }
            .background(model.backColor)
            .clipShape(
                RoundedRectangle(cornerRadius: 30)
            )
        }
    }
}
