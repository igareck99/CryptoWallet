import SwiftUI

// MARK: - SecurityCellView

struct SecurityCellView: View {

    // MARK: - Internal Properties

    var title: String
    var font: Palette = .darkGray()
    var currentState: String

    // MARK: - Body

    var body: some View {
        HStack {
            Text(title)
                .font(.regular(15))
            Spacer()
            HStack(spacing: 17) {
                Text(currentState.isEmpty ? R.string.localizable.securityProfileObserveState() :
                        currentState)
                    .font(.regular(15))
                    .foreground(font)
                R.image.registration.arrow.image
            }
        }
    }
}
