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
                    .font(.regular(15))
                Text(description)
                    .font(.regular(12))
                    .foreground(.gray())
            }
            Spacer()
            Toggle("", isOn: $currentState)
                .labelsHidden()
                .toggleStyle(SwitchToggleStyle(tint: .green))
        }
    }
}
