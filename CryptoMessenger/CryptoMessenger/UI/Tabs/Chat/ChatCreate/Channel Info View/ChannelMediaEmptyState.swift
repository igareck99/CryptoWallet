import SwiftUI

// MARK: - ChannelMediaEmptyState

struct ChannelMediaEmptyState: View {

    // MARK: - Internal Properties

    let image: Image
    let title: String
    let description: String

    // MARK: - Body

    var body: some View {
        VStack(alignment: .center) {
            image
                .resizable()
                .frame(width: 250, height: 143)
            Text(title)
                .font(.title2Regular22)
            Text(description)
                .font(.subheadlineRegular15)
                .foregroundColor(.romanSilver)
        }
    }
}
