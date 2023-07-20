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
                .foregroundColor(viewModel.resources.backgroundFodding)
                .padding(.top, 6)
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .frame(width: 40, height: 40)
                        .foregroundColor(viewModel.resources.avatarBackground)
                    viewModel.resources.pencilImage
                }
                Text("Редактировать", [
                    .paragraph(.init(lineHeightMultiple: 1.22, alignment: .left))
                ])
                .font(.system(size: 17, weight: .regular))
                .foregroundColor(viewModel.resources.buttonBackground)
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
                        .foregroundColor(viewModel.resources.negativeColor)
                    viewModel.resources.trashBasketImage
                }
                Text(viewModel.resources.callListDelete, [
                    .paragraph(.init(lineHeightMultiple: 1.22, alignment: .left))
                ])
                .font(.system(size: 17, weight: .regular))
                .foregroundColor(viewModel.resources.negativeColor)
                Spacer()
            }
            .padding(.leading, 16)
            Spacer()
        }
    }
}
