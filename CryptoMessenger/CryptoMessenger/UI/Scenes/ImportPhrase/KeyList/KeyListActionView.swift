import SwiftUI

// MARK: - KeyListActionView

struct KeyListActionView: View {

    // MARK: - Internal Properties

    @Binding var showActionSheet: Bool
    @StateObject var viewModel: KeyListViewModel

    // MARK: - Body

    var body: some View {
        VStack(spacing: 18) {
            RoundedRectangle(cornerRadius: 2)
                .frame(width: 31, height: 4)
                .foreground(.darkGray(0.4))
                .padding(.top, 6)
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .frame(width: 40, height: 40)
                        .foreground(.blue(0.1))
                    R.image.keyManager.pencil.image
                }
                Text("Редактировать", [
                    .paragraph(.init(lineHeightMultiple: 1.22, alignment: .left)),
                    .font(.regular(17)),
                    .color(.blue())
                ])
                Spacer()
            }
            .onTapGesture {
                showActionSheet = false
                viewModel.send(.onImportKey)
            }
            .padding(.leading, 16)
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .frame(width: 40, height: 40)
                        .foreground(.red(0.1))
                    R.image.keyManager.trashBasket.image
                }
                Text(R.string.localizable.callListDelete(), [
                    .paragraph(.init(lineHeightMultiple: 1.22, alignment: .left)),
                    .font(.regular(17)),
                    .color(.red())
                ])
                Spacer()
            }
            .padding(.leading, 16)
            Spacer()
        }
    }
}
