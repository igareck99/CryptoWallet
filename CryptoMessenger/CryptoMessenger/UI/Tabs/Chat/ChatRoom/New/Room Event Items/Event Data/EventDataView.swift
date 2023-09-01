import SwiftUI

struct EventDataView<ReadData: View>: View {
    let model: EventData
    let readData: ReadData
    var body: some View {
        HStack(spacing: .zero) {
            Spacer()
            HStack(spacing: 4) {
                Text(model.date)
                    .font(.system(size: 11, weight: .regular))
                    .foregroundColor(model.dateColor)
                    .padding(.leading, 4)
                readData
                    .padding(.trailing, 4)
            }
            .background(model.backColor)
            .clipShape(
                RoundedRectangle(cornerRadius: 30)
            )
        }
    }
}