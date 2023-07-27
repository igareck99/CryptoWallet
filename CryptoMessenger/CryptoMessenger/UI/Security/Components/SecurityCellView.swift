import SwiftUI

// MARK: - SecurityCellView

struct SecurityCellView: View {

    // MARK: - Internal Properties

    var title: String
    var currentState: String

    // MARK: - Body

    var body: some View {
        HStack {
            Text(title)
                .font(.system(size: 15, weight: .regular))
            Spacer()
            HStack(spacing: 17) {
                Text(currentState.isEmpty ? R.string.localizable.securityProfileObserveState() :
                        currentState)
                    .font(.system(size: 15, weight: .regular))
                    .foregroundColor(.chineseBlack)
                R.image.registration.arrow.image
            }
        }
    }
}
