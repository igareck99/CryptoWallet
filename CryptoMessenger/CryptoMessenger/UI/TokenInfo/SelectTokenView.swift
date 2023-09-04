import SwiftUI

// MARK: - SelectTokenView

struct SelectTokenView: View {

    // MARK: - Internal Properties

    @Binding var showSelectToken: Bool
    @Binding var address: WalletInfo
    @StateObject var viewModel: TokenInfoViewModel

    // MARK: - Body

    var body: some View {
        VStack {
            VStack(spacing: 16) {
                RoundedRectangle(cornerRadius: 2)
                    .frame(width: 31, height: 4)
                    .foreground(.romanSilver07)
                    .padding(.top, 6)
                ForEach(viewModel.addresses) { item in
                    AddSelectorTokenCellView(address: item)
                        .background(.white)
                        .padding(.horizontal, 16)
                        .onTapGesture {
                            showSelectToken = false
                            address = item
                        }
                }
            }
            Spacer()
        }
    }
}

// MARK: - AddSelectorTokenCellView

struct AddSelectorTokenCellView: View {

    // MARK: - Internal Properties

    @State var address: WalletInfo

    // MARK: - Body

    var body: some View {
        HStack(alignment: .center ) {
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(Color.dodgerTransBlue)
                        .frame(width: 40, height: 40)
                    R.image.chat.logo.image
                }
                VStack(alignment: .leading, spacing: 2) {
                    Text(address.address)
                        .font(.system(size: 15, weight: .medium))
                        .frame(height: 22)
                    Text(String(address.coinAmount) + " \(address.result.currency)")
                        .font(.system(size: 12, weight: .regular))
                        .foreground(.romanSilver)
                        .frame(height: 20)
                }
            }
            Spacer()
        }
    }
}
