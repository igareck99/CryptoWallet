import SwiftUI

// MARK: - ChatHistorySearchCell

struct ChatHistorySearchRow: View {

    // MARK: - Internal Properties

    private let data: MatrixChannel
    @State private var url: URL?

    // MARK: - Lifecycle

    init(data: MatrixChannel) {
        self.data = data
        if !data.avatarUrl.isEmpty {
            self.url = URL(string: data.avatarUrl)
        }
    }

    // MARK: - Body

    var body: some View {
        HStack(alignment: .center, spacing: 0) {
            avatarView.padding(.init(top: 2, leading: 14, bottom: 0, trailing: 0))
            VStack(alignment: .leading, spacing: 2) {
                Text(data.name)
                    .font(.system(size: 17, weight: .regular))
                Text("\(data.numJoinedMembers) участника")
                    .font(.system(size: 12, weight: .regular))
                    .foreground(.romanSilver)
            }.padding(.init(top: 10, leading: 10, bottom: 0, trailing: 0))
            Spacer()
        }.frame(height: 64)
            .onTapGesture {
                data.onTap(data)
            }
    }
    
    private var avatarView: some View {
        AsyncImage(
            defaultUrl: url,
            updatingPhoto: false,
            url: $url,
            placeholder: {
                ZStack {
                    Color(.lightBlue())
                    Text(data.name.firstLetter.uppercased() ?? "?")
                        .foreground(.white)
                        .font(.system(size: 20, weight: .medium))
                }
            },
            result: {
                Image(uiImage: $0).resizable()
            }
        )
        .scaledToFill()
        .frame(width: 40, height: 40)
        .cornerRadius(20)
    }
}
