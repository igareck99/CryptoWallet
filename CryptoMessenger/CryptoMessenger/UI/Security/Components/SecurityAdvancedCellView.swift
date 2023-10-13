import SwiftUI

// MARK: - SecurityAdvancedCellView

struct SecurityAdvancedCellView: View {

    // MARK: - Internal Properties

    var title: String
    var description: String
    @Binding var currentState: Bool

    // MARK: - Body

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.bodyRegular17)
                Text(description)
                    .font(.caption1Regular12)
                    .foregroundColor(.romanSilver)
            }
            Spacer()
            Toggle("", isOn: $currentState)
                .labelsHidden()
                .toggleStyle(SwitchToggleStyle(tint: .greenCrayola))
        }
    }
}
