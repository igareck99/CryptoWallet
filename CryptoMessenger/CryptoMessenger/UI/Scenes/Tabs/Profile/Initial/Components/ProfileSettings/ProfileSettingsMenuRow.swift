import SwiftUI

// MARK: - ProfileSettingsMenuRow

struct ProfileSettingsMenuRow: View {

    // MARK: - Internal Properties

    let title: String
    let image: Image
    let notifications: Int

    // MARK: - Body

    var body: some View {
        HStack(spacing: 0) {
            ZStack {
                Circle()
                    .fill(Color(.blue(0.1)))
                    .frame(width: 40, height: 40)
                image
                    .frame(width: 20, height: 20)
            }

            Text(title)
                .font(.regular(15))
                .padding(.leading, 16)

            Spacer()

            if notifications > 0 {
                ZStack {
                    Image(uiImage: UIImage())
                        .frame(width: 20, height: 20)
                        .background(.lightRed())
                        .clipShape(Circle())
                    Text(notifications.description)
                        .font(.regular(15))
                        .foreground(.white())
                }
            }

            R.image.additionalMenu.grayArrow.image
        }
    }
}
