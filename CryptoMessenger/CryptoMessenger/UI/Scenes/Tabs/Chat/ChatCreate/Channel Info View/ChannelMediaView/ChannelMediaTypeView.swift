import SwiftUI

// MARK: - ChannelMediaTypeView

struct ChannelMediaTypeView: View {

    // MARK: - Internal Properties

    @Binding var selectedSearchType: ChannelMediaTabs
    @State var searchTypeCell: ChannelMediaTabs

    // MARK: - Body

    var body: some View {
        VStack(spacing: 9) {
            Text(searchTypeCell.title,
                 [
                    .paragraph(.init(lineHeightMultiple: 1.15, alignment: .center))
                 ]).font(.system(size: 16, weight: .regular))
                .foregroundColor(searchTypeCell == selectedSearchType ? .dodgerBlue : .romanSilver)
            Divider()
                .frame(width: UIScreen.main.bounds.width / 2,
                       height: searchTypeCell == selectedSearchType ? 2 : 1)
                .background(searchTypeCell == selectedSearchType ? Color.dodgerBlue : Color.gainsboro)
        }
        .frame(height: 44, alignment: .bottom)
        .onTapGesture {
            withAnimation(.linear(duration: 0.35)) {
                selectedSearchType = searchTypeCell
            }
        }
    }
}
