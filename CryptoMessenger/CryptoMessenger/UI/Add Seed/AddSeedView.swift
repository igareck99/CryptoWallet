import SwiftUI

struct AddSeedView<ViewModel: AddSeedViewModelProtocol>: View {

    @StateObject var viewModel: ViewModel

    var body: some View {
        VStack(spacing: 18) {
            RoundedRectangle(cornerRadius: 2)
                .frame(width: 31, height: 4)
                .foregroundColor(.chineseBlack04)
                .padding(.top, 6)
            HStack {
                ZStack {
                    Circle()
                        .frame(width: 40, height: 40)
                        .foregroundColor(.dodgerTransBlue)
                    R.image.transaction.bluePlus.image
                }
                Text(R.string.localizable.transactionAddWallet())
                    .font(.system(size: 17, weight: .regular))
                    .foregroundColor(.dodgerBlue)
                Spacer()
            }
            .padding(.leading, 16)
            .onTapGesture {
                viewModel.onImportKeyTap()
            }
            Spacer()
        }
    }
}
