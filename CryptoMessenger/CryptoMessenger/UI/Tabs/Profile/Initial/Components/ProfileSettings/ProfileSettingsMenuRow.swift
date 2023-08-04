import SwiftUI

// MARK: - ProfileSettingsMenuRow

struct ProfileSettingsMenuRow: View {

    // MARK: - Internal Properties

    let title: String
    let image: Image
    let notifications: Int
    var color: Color = .chineseBlack04

    // MARK: - Body

    var body: some View {
        HStack(spacing: 0) {
            image
            Text(title)
                .font(.regular(15))
                .padding(.leading, 16)
                .foregroundColor(color)

            Spacer()

            if notifications > 0 {
                ZStack {
                    Image(uiImage: UIImage())
                        .frame(width: 20, height: 20)
                        .background(Color.spanishCrimson)
                        .clipShape(Circle())
                    Text(notifications.description)
                        .font(.regular(15))
                        .foregroundColor(.white)
                }
            }

            R.image.additionalMenu.grayArrow.image
        }
    }
}
