import SwiftUI

// MARK: - ProfileSettingsMenuRow

struct ProfileSettingsMenuRow: View {

    // MARK: - Internal Properties

    let title: String
    let image: Image
    let notifications: Int
    let showArrow = true
    var color: Color = .chineseBlack

    // MARK: - Body

    var body: some View {
        HStack(spacing: 0) {
            image
            Text(title)
                .font(.calloutRegular16)
                .padding(.leading, 10)
                .foregroundColor(color)
            Spacer()
            if notifications > 0 {
                ZStack {
                    Image(uiImage: UIImage())
                        .frame(width: 20, height: 20)
                        .background(Color.spanishCrimson)
                        .clipShape(Circle())
                    Text(notifications.description)
                        .font(.subheadlineRegular15)
                        .foregroundColor(.white)
                }
            }
            if showArrow {
                Image(systemName: "chevron.right")
                    .resizable()
                    .frame(width: 7.16, height: 12.3, alignment: .center)
                    .foregroundColor(.romanSilver)
            }
        }
    }
}
