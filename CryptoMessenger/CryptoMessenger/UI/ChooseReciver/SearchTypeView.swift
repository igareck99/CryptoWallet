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
                    .paragraph(.init(lineHeightMultiple: 1.21, alignment: .center))
                 ])
                .font(.system(size: 16, weight: .regular))
                .foregroundColor(searchTypeCell == selectedSearchType ? .dodgerBlue: .romanSilver)
            Divider()
                .frame(width: UIScreen.main.bounds.width / 2, height: 2)
                .background(Color.dodgerBlue)
                .opacity(searchTypeCell == selectedSearchType ? 1 : 0)
        }
        .onTapGesture {
            withAnimation(.easeOut(duration: 0.3)) {
                selectedSearchType = searchTypeCell
            }
        }
    }
}
