import SwiftUI

// MARK: - ChatHistorySearchCell

struct ChatHistorySearchRow: View {

    // MARK: - Internal Properties

    private var name: String
    private var numberUsers: Int
    private var avatarString: String
    @State private var url: URL?

    // MARK: - Lifecycle

    init(name: String, numberUsers: Int,
         avatarString: String) {
        self.name = name
        self.numberUsers = numberUsers
        self.avatarString = avatarString
        if !avatarString.isEmpty {
            self.url = URL(string: avatarString)
        }
    }

    // MARK: - Body

    var body: some View {
        HStack(alignment: .center, spacing: 0) {
            avatarView.padding(.init(top: 2, leading: 14, bottom: 0, trailing: 0))
            VStack(alignment: .leading, spacing: 2) {
                Text(name)
                    .font(.regular(17))
                Text("\(numberUsers) участника")
                    .font(.regular(12))
                    .foreground(.darkGray())
            }.padding(.init(top: 10, leading: 10, bottom: 0, trailing: 0))
            Spacer()
        }.frame(height: 64)
    }
    
    private var avatarView: some View {
        AsyncImage(
            defaultUrl: url,
            updatingPhoto: false,
            url: $url,
            placeholder: {
                ZStack {
                    Color(.lightBlue())
                    Text(name.firstLetter.uppercased() ?? "?")
                        .foreground(.white())
                        .font(.medium(20))
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
