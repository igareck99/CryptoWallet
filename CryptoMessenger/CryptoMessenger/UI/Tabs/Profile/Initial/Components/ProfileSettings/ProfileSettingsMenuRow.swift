import SwiftUI

// MARK: - ProfileSettingsMenuRow

struct ProfileSettingsMenuRow: View {

    // MARK: - Internal Properties

    let title: String
    let image: Image
    let notifications: Int
    let showArrow = true
    var color: Color = .chineseBlack04

    // MARK: - Body

    var body: some View {
        HStack(spacing: 0) {
            image
            Text(title)
                .font(.system(size: 15, weight: .regular))
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
                        .font(.system(size: 15, weight: .regular))
                        .foregroundColor(.white)
                }
            }
            if showArrow {
                R.image.additionalMenu.grayArrow.image
            }
        }
    }
}
