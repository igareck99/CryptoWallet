import SwiftUI

// MARK: - ProfileDetailActionRow

struct ProfileDetailActionRow: View {

    // MARK: - Internal Properties

    let title: String
    let image: Image

    // MARK: - Body

    var body: some View {
        HStack(spacing: 0) {
            image
                .frame(width: 20, height: 20)
            Text(title)
                .font(.system(size: 15, weight: .regular))
                .padding(.leading, 16)
            Spacer()
            R.image.additionalMenu.grayArrow.image
        }
    }
}

