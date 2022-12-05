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
		ScrollView {
			content.popup(
				isPresented: $showAddresses,
				type: .toast,
				position: .bottom,
				closeOnTap: false,
				closeOnTapOutside: true,
				backgroundColor: Color(.black(0.4))
			) {
				SelectTokenView(
					showSelectToken: $showAddresses,
					address: $address,
					viewModel: viewModel
				)
				.frame(
					width: UIScreen.main.bounds.width,
					height: CGFloat(viewModel.addresses.count * 64 + 50),
					alignment: .center
				)
				.background(.white())
				.cornerRadius(16)
			}
			.navigationBarTitleDisplayMode(.inline)
			.navigationBarHidden(false)
			.navigationBarTitle(R.string.localizable.tokenInfoTitle())
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
        VStack(alignment: .center) {
            QRCodeView
                .padding(.top, 40)

			copyAddressButton
				.padding(.bottom, 80)

			shareButton
				.frame(width: 225, height: 44)
				.padding(.bottom, 44)
        }
		.padding([.leading, .trailing], 16)
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

	private var copyAddressButton: some View {
		HStack(spacing: 0) {

			Text(address.address)
				.lineLimit(1)
				.truncationMode(.middle)
				.font(.system(size: 16))
				.foregroundColor(.manateeApprox)
				.padding(.leading, 8)
				.padding(.trailing, 16)

			Image(R.image.wallet.copy.name)
				.foregroundColor(.sharkApprox)
				.padding(.trailing, 8)
				.onTapGesture {
					UIPasteboard.general.string = address.address
				}
		}
		.frame(minHeight: 50)
		.overlay(
			RoundedRectangle(cornerRadius: 6)
				.stroke(Color.athensGrayApprox, lineWidth: 2)
		)

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

    private var shareButton: some View {
		Button(action: actionSheet) {
			Text(R.string.localizable.tokenInfoShareAddress())
				.frame(minWidth: 0, maxWidth: 225)
				.font(.semibold(15))
				.padding()
				.foregroundColor(.white)
				.overlay(
					RoundedRectangle(cornerRadius: 8)
						.stroke(Color.white, lineWidth: 2)
				)
		}
		.background(Color(.blue()))
		.cornerRadius(8)
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

	private func actionSheet() {

		guard
			let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
			let controller = scene.windows.first?.rootViewController
		else {
			return
		}

		let activityVC = UIActivityViewController(
			activityItems: [address.address],
			applicationActivities: nil
		)

		controller.present(
			activityVC,
			animated: true,
			completion: nil
		)
	}
}
