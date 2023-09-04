import SwiftUI

// MARK: - PrivacyCellView

struct PrivacyCellView: View {

    // MARK: - Internal Properties

    let item: SecurityCellItem
    var phraseStatus = false

    // MARK: - Body

    var body: some View {
        HStack(alignment: .center) {
            VStack(alignment: .leading, spacing: 2) {
                Text(item.result.title)
                    .font(.system(size: 17, weight: .regular))
                if !item.result.state.isEmpty {
                    Text(item.result.state)
                        .font(.system(size: 12, weight: .regular))
                        .foregroundColor(.chineseBlack)
                        .lineLimit(2)
                }
            }
            Spacer()
            if item == .seedPhrase {
                if phraseStatus {
                    R.image.countryCode.check.image
                        .frame(width: 14.3,
                               height: 14.3)
                } else {
                    R.image.session.phraseWarning.image
                }
            } else {
                R.image.registration.arrow.image
            }
        }
    }
}
