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
                .font(.system(size: 22, weight: .bold))
            Text(description)
                .font(.system(size: 15, weight: .regular))
                .foregroundColor(.romanSilver)
        }
    }
}
