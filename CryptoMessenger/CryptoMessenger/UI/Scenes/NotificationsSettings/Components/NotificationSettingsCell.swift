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
                    .font(.regular(15))
                if !field.item.description.isEmpty {
                    Text(field.item.description)
                        .font(.regular(12))
                        .foreground(.gray())
                        .padding(.top, 4)
                }
            }
            Spacer()
            Toggle("", isOn: $field.state)
                .labelsHidden()
                .toggleStyle(SwitchToggleStyle(tint: .green))
        }
    }
}
