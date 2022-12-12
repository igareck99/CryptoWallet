import SwiftUI


// MARK: - ChatMediaTypeView

struct ChatMediaTypeView: View {

    // MARK: - Internal Properties

    @Binding var selectedSearchType: ChatMediaTabs
    @State var searchTypeCell: ChatMediaTabs

    // MARK: - Body

    var body: some View {
        VStack(spacing: 7) {
            Text(searchTypeCell.title,
                 [
                    .paragraph(.init(lineHeightMultiple: 1.15, alignment: .center)),
                    .font(.regular(13)),
                    .color(searchTypeCell == selectedSearchType ? .blue(): .darkGray())
                 ])
            Divider()
                .frame(height: 2)
                .background(.blue())
                .opacity(searchTypeCell == selectedSearchType ? 1 : 0)
        }
        .frame(minWidth: 53,
               maxWidth: 72,
               alignment: .center)
        .onTapGesture {
            selectedSearchType = searchTypeCell
        }
    }
}
