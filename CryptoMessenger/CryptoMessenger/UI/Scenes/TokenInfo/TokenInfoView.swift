import SwiftUI
import CoreImage.CIFilterBuiltins

// MARK: - TokenInfoView

struct TokenInfoView: View {

    // MARK: - Internal Properties

    @Binding var showTokenInfo: Bool
    @StateObject var viewModel: TokenInfoViewModel
    @State var showAddresses = false
    let context = CIContext()
    let filter = CIFilter.qrCodeGenerator()
    @State var address: WalletInfo

    // MARK: - Body

    var body: some View {
        content
            .popup(isPresented: $showAddresses,
                   type: .toast,
                   position: .bottom,
                   closeOnTap: false,
                   closeOnTapOutside: true,
                   backgroundColor: Color(.black(0.4))) {
                SelectTokenView(showSelectToken: $showAddresses,
                                address: $address,
                                viewModel: viewModel)
                    .frame(width: UIScreen.main.bounds.width,
                           height: CGFloat(viewModel.addresses.count * 64 + 50),
                           alignment: .center)
                    .background(.white())
                    .cornerRadius(16)
            }
    }

    // MARK: - Private Properties

    private var headerView: some View {
        HStack {
            R.image.buyCellsMenu.close.image
                .onTapGesture {
                    showTokenInfo = false
                }
            Spacer()
            Text(R.string.localizable.tokenInfoTitle())
                .font(.bold(15))
            Spacer()
        }
    }

    private var content: some View {
        VStack(alignment: .leading) {
            headerView
                .padding(.top, 16)
                .padding(.horizontal, 16)
            Divider()
                .padding(.top, 16)
            QRCodeView
                .padding(.leading, 16)
                .padding(.top, 40)
            Text(R.string.localizable.tokenInfoSelectedAddress().uppercased())
                .font(.semibold(12))
                .foreground(.darkGray())
                .padding(.top, 24)
                .padding(.leading, 16)
            addressCell
                .background(.white())
                .onTapGesture {
                    showAddresses = true
                }
                .padding(.top, 12)
                .padding(.horizontal, 16)
            Spacer()
            VStack(spacing: 16) {
                Divider()
                sendButton
                    .frame(width: 225, height: 44)
                    .padding(.bottom, 44)
            }
        }
    }

    private var QRCodeView: some View {
        ZStack {
            generateQRCode(from: "\(address)")
                .resizable()
                .scaledToFit()
                .frame(width: UIScreen.main.bounds.width - 66,
                       height: UIScreen.main.bounds.width - 66)
            RoundedRectangle(cornerRadius: 8.0)
                .stroke(Color(.gray()))
                .frame(width: UIScreen.main.bounds.width - 32,
                       height: UIScreen.main.bounds.width - 32)
        }
    }

    private var addressCell: some View {
        HStack(alignment: .center ) {
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(Color(.blue(0.1)))
                        .frame(width: 40, height: 40)
                    R.image.chat.logo.image
                }
                VStack(alignment: .leading, spacing: 2) {
                    Text(address.address)
                        .font(.medium(15))
                        .frame(height: 22)
                    Text(String(address.coinAmount) + " \(address.result.currency)")
                        .font(.regular(12))
                        .foreground(.darkGray())
                        .frame(height: 20)
                }
            }
            Spacer()
            R.image.profileDetail.arrow.image
                .frame(width: 20,
                       height: 20,
                       alignment: .center)
        }
    }

    private var sendButton: some View {
        Button {
        } label: {
            Text(R.string.localizable.tokenInfoShareAddress())
                .frame(minWidth: 0, maxWidth: 225)
                .font(.semibold(15))
                .padding()
                .foregroundColor(.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 4)
                        .stroke(Color.white, lineWidth: 2)
                )
        }
        .background(Color(.blue()))
        .cornerRadius(4)
    }

    // MARK: - Private Methods

    private func generateQRCode(from string: String) -> Image {
        filter.message = Data(string.utf8)
        if let outputImage = filter.outputImage {
            if let image = context.createCGImage(outputImage, from: outputImage.extent) {
                return Image(uiImage: UIImage(cgImage: image))
                    .interpolation(.none)
            }
        }
        return Image(uiImage: UIImage(systemName: "xmark.circle") ?? UIImage())
            .interpolation(.none)
    }
}
