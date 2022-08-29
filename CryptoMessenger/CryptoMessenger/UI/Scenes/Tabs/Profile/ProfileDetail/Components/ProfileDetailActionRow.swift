import SwiftUI

// MARK: - ProfileDetailActionRow

struct ProfileDetailActionRow: View {

    // MARK: - Internal Properties

    let title: String
    let color: Palette
    let image: Image

    // MARK: - Body

    var body: some View {
        HStack(spacing: 0) {
            ZStack {
                Circle()
                    .fill(Color(color))
                    .frame(width: 40, height: 40)
                image
                    .frame(width: 20, height: 20)
            }
            Text(title)
                .font(.regular(15))
                .padding(.leading, 16)
            Spacer()
            R.image.additionalMenu.grayArrow.image
        }
    }
}

