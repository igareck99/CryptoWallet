import SwiftUI

// MARK: - ProfileDetailActionRow

struct ProfileDetailActionRow: View {

    // MARK: - Internal Properties

    let title: String
    let image: Image

    // MARK: - Body

    var body: some View {
        HStack(spacing: 0) {
            HStack(alignment: .center, spacing: 16) {
                image
                    .resizable()
                    .frame(width: 30, height: 30)
                Text(title)
                    .font(Font.bodyRegular17)
            }
            Spacer()
            Image(systemName: "chevron.right")
                .resizable()
                .frame(width: 7.16, height: 12.3)
                .foreground(.lightGray)
        }
    }
}

