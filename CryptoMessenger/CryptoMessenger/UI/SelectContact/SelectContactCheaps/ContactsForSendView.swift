import SwiftUI

// MARK: - ContactsForSendView

struct ContactsForSendView: View {

    // MARK: - Internal Properties

    @Binding var views: [any ViewGeneratable]
    @Binding var text: String

    // MARK: - Body

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Divider()
            SelectContactChips(views: views, text: $text).view()
                    .padding(.horizontal, 16)
            Divider()
        }
    }
}
