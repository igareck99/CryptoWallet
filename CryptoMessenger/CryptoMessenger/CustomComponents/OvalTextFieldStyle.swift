import SwiftUI

// MARK: - OvalTextFieldStyle

struct OvalTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(.vertical, 12)
            .padding(.leading, 16)
            .font(.bodyRegular17)
            .background(
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .foreground(.aliceBlue)
            )
    }
}
