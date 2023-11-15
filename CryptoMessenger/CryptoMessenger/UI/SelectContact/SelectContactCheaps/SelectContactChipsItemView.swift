import SwiftUI

// MARK: - SelectContactChipsItemView

struct SelectContactChipsItemView: View {

    let data: SelectContactChipsItem

    var body: some View {
        ZStack(alignment: .center) {
            Rectangle()
                .frame(width: data.getItemWidth() + 16, height: 30)
                .foreground(.dodgerBlue)
                .cornerRadius(6)
            Text(data.name)
                .font(.regular(17))
                .foreground(.white)
                .frame(width: data.getItemWidth())
        }
    }
}
