import SwiftUI

// MARK: - SearchTypeView

struct SearchTypeView: View {

    // MARK: - Internal Properties

    @Binding var selectedSearchType: SearchType
    @State var searchTypeCell: SearchType

    // MARK: - Body

    var body: some View {
        VStack(alignment: .center, spacing: 7) {
            Text(searchTypeCell.result,
                 [
                    .paragraph(.init(lineHeightMultiple: 1.21, alignment: .center)),
                    .font(.regular(16)),
                    .color(searchTypeCell == selectedSearchType ? .blue(): .darkGray())
                 ])
            Divider()
                .frame(width: UIScreen.main.bounds.width / 2, height: 2)
                .background(.blue())
                .opacity(searchTypeCell == selectedSearchType ? 1 : 0)
        }
        .onTapGesture {
            withAnimation(.easeOut(duration: 0.3)) {
                selectedSearchType = searchTypeCell
            }
        }
    }
}
