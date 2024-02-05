import SwiftUI

// MARK: - SaveToCameraCellView

struct NotificationSettingsCell: View {

    // MARK: - Internal Properties

    @Binding var field: NotificationSettings

    // MARK: - Body

    var body: some View {
        HStack(alignment: .center) {
            VStack(alignment: .leading, spacing: 2) {
                Text(field.item.title)
                    .font(.bodyRegular17)
                if !field.item.description.isEmpty {
                    Text(field.item.description)
                        .font(.caption1Regular12)
                        .foregroundColor(.romanSilver)
                        .padding(.top, 4)
                }
            }
            Spacer()
            Toggle("", isOn: $field.state)
                .labelsHidden()
                .toggleStyle(SwitchToggleStyle(tint: .greenCrayola))
        }
    }
}
