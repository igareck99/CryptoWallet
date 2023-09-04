import SwiftUI

// MARK: - SaveToCameraCellView

struct NotificationSettingsCell: View {

    // MARK: - Internal Properties

    @Binding var field: NotificationSettings

    // MARK: - Body

    var body: some View {
        HStack(alignment: .center) {
            VStack(alignment: .leading, spacing: 4) {
                Text(field.item.title)
                    .font(.system(size: 15, weight: .regular))
                if !field.item.description.isEmpty {
                    Text(field.item.description)
                        .font(.system(size: 12, weight: .regular))
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
