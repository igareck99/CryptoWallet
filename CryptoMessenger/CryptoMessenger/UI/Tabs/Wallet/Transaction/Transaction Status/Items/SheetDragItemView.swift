import SwiftUI

struct SheetDragItemView: View {
    let model: SheetDragItem
    var body: some View {
        VStack(alignment: .center, spacing: .zero) {
            RoundedRectangle(cornerRadius: 2)
                .frame(width: 31, height: 4)
                .foregroundColor(model.itemColor)
                .padding(.top, 5)
                .padding(.bottom, 16)
        }
        .frame(height: 18)
    }
}
