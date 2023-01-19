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

    // MARK: - Body

	var body: some View {
		VStack(spacing: 0) {
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
                        address: $viewModel.address,
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

            shareButton
                .frame(height: 48)
                .padding(.bottom)
                .popup(
                    isPresented: viewModel.isSnackbarPresented,
                    alignment: .bottom
                ) {
                    Snackbar(
                        text: R.string.localizable.tokenInfoAddressCopied(),
                        color: .green
                    )
                }
        }
        .ignoresSafeArea(.keyboard)
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
        }
		.padding([.leading, .trailing], 16)
    }

    private var QRCodeView: some View {
        ZStack {
            generateQRCode(from: "\(viewModel.address.address)")
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

            Text(viewModel.address.address)
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
                    UIPasteboard.general.string = viewModel.address.address
					viewModel.onAddressCopy()
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
                    Text(viewModel.address.address)
                        .font(.medium(15))
                        .frame(height: 22)
                    Text(String(viewModel.address.coinAmount) + " \(viewModel.address.result.currency)")
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
				.frame(width: 225, height: 48)
				.font(.semibold(15))
				.padding()
				.foregroundColor(.white)
				.background(
					Rectangle()
						.fill(Color.azureRadianceApprox)
						.cornerRadius(8)
						.frame(height: 48)
				)
		}
		.frame(maxWidth: .infinity)
		.frame(height: 48)
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
            activityItems: [$viewModel.address.address],
            applicationActivities: nil
        )

		controller.present(
			activityVC,
			animated: true,
			completion: nil
		)
	}
}
