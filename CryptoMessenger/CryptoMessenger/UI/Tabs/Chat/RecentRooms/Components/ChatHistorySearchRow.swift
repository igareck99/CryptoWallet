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
        VStack {
            HStack(alignment: .center, spacing: 10) {
                avatarView.padding(.leading, 16)
                VStack(alignment: .leading, spacing: 2) {
                    Text(data.name)
                        .font(.system(size: 17, weight: .regular))
                    Text("\(data.numJoinedMembers) участника")
                        .font(.system(size: 12, weight: .regular))
                        .foreground(.romanSilver)
                }
                Spacer()
            }
            .padding(.bottom, 12)
            Divider()
                .padding(.leading, 66)
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
                    Color(.aliceBlue)
                    Text(data.name.firstLetter.uppercased())
                        .foreground(.white)
                        .font(.title3Semibold20)
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
