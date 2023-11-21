import SwiftUI

struct SheetDragItemView: View {
    let model: SheetDragItem
    var body: some View {
        HStack(alignment: .center, spacing: .zero) {
            Spacer()
            RoundedRectangle(cornerRadius: 2)
                .frame(width: 31, height: 4)
                .foregroundColor(model.itemColor)
                .padding(.top, 5)
                .padding(.bottom, 16)
            Spacer()
        }
        .frame(height: 18)
    }
}
