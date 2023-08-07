import SwiftUI
import CoreImage.CIFilterBuiltins

// MARK: - TokenInfoView

struct TokenInfoView: View {

    // MARK: - Internal Properties

    @StateObject var viewModel: TokenInfoViewModel
    @State var showAddresses = false
    let context = CIContext()
    let filter = CIFilter.qrCodeGenerator()

    // MARK: - Body

    var body: some View {
        ScrollView {
            content.popup(
                isPresented: $showAddresses,
                type: .toast,
                position: .bottom,
                closeOnTap: false,
                closeOnTapOutside: true,
                backgroundColor: viewModel.resources.backgroundFodding
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
                .background(viewModel.resources.background)
                .cornerRadius(16)
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarHidden(false)
            .navigationBarTitle(viewModel.resources.tokenInfoTitle)
        }
        .popup(
            isPresented: viewModel.isSnackbarPresented,
            alignment: .bottom
        ) {
            Snackbar(
                text: viewModel.resources.tokenInfoAddressCopied,
                color: viewModel.resources.buttonBackground
            )
        }
    }

    // MARK: - Private Properties

    private var content: some View {
        VStack(alignment: .center) {
            Spacer()
                .frame(height: 50)

            QRCodeView
                .padding(.bottom, 20)

			copyAddressButton
				.padding(.bottom, 32)
                .padding(.horizontal, 16)

            shareButton
                .frame(height: 48)

            Spacer()
        }
        .padding(.horizontal, 16)
    }

    private var QRCodeView: some View {
        ZStack {
            generateQRCode(from: "\(viewModel.address.address)")
                .resizable()
                .scaledToFit()
                .frame(width: UIScreen.main.bounds.width - 66,
                       height: UIScreen.main.bounds.width - 66)
            RoundedRectangle(cornerRadius: 8.0)
                .stroke(viewModel.resources.rectangleColor, lineWidth: 1)
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
                .foregroundColor(viewModel.resources.textColor)
				.padding(.horizontal, 16)

            viewModel.resources.copy
                .foregroundColor(viewModel.resources.titleColor)
				.padding(.trailing, 8)
				.onTapGesture {
                    UIPasteboard.general.string = viewModel.address.address
					viewModel.onAddressCopy()
				}
		}
		.frame(minHeight: 50)
		.overlay(
			RoundedRectangle(cornerRadius: 8)
                .stroke(viewModel.resources.rectangleColor, lineWidth: 1)
		)
	}

    private var addressCell: some View {
        HStack(alignment: .center ) {
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(viewModel.resources.logoBackground)
                        .frame(width: 40, height: 40)
                    R.image.chat.logo.image
                }
                VStack(alignment: .leading, spacing: 2) {
                    Text(viewModel.address.address)
                        .font(.system(size: 15, weight: .medium))
                        .frame(height: 22)
                    Text(String(viewModel.address.coinAmount) + " \(viewModel.address.result.currency)")
                        .font(.system(size: 12, weight: .regular))
                        .foregroundColor(viewModel.resources.textColor)
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
            Text(viewModel.resources.tokenInfoShareAddress)
				.frame(width: 225, height: 48)
                .font(.system(size: 17, weight: .semibold))
				.padding()
                .foregroundColor(viewModel.resources.background)
				.background(
					Rectangle()
                        .fill(viewModel.resources.buttonBackground)
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
        return viewModel.resources.xmarkCircle
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
