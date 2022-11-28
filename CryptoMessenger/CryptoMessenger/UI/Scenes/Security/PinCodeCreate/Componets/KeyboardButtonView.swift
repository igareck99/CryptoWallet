import SwiftUI

// MARK: - KeyboardButtonView

struct KeyboardButtonView: View {

    // MARK: - Internal Properties

    var button: KeyboardButtonType

    // MARK: - Body

    var body: some View {
        switch button {
        case .delete:
            Image(uiImage: R.image.pinCode.delete() ?? UIImage())
        case let .number(value):
            ZStack {
                Circle()
                    .fill(Color(.blue(0.1)))
                    .frame(width: 67, height: 67)
                Text(String(value))
                    .font(.regular(24))
            }
        default:
            Circle()
                .fill(Color(.clear))
                .frame(width: 67, height: 67)
        }
    }
}
