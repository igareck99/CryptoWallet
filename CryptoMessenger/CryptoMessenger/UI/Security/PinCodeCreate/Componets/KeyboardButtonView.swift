import SwiftUI

// MARK: - KeyboardButtonView

struct KeyboardButtonView: View {

    // MARK: - Internal Properties

    var button: KeyboardButtonType

    // MARK: - Body

    var body: some View {
        switch button {
        case .delete:
            R.image.pinCode.delete.image
        case let .number(value):
            ZStack {
                Circle()
                    .fill(Color.dodgerTransBlue)
                    .frame(width: 80, height: 80)
                Text(String(value))
                    .font(.system(size: 24, weight: .regular))
            }
        case .faceId:
            ZStack(alignment: .center) {
                R.image.pinCode.faceId.image
                    .resizable()
                    .frame(width: 30, height: 30)
            }
        case .touchId:
            ZStack(alignment: .center) {
                R.image.pinCode.touchId.image
                    .resizable()
                    .frame(width: 30, height: 30)
            }
        default:
            Circle()
                .fill(Color(.clear))
                .frame(width: 67, height: 67)
        }
    }
}
