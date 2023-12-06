import SwiftUI

struct TokenInfoView<ViewModel: TokenInfoViewModelProtocol>: View {

    @StateObject var viewModel: ViewModel
    @Environment(\.presentationMode) private var presentationMode

    // MARK: - Body

    var body: some View {
        NavigationView {
            ScrollView {
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
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarHidden(false)
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .tabBar)
        .toolbar {
            createToolBar()
        }
    }

    private var QRCodeView: some View {
        ZStack {
            viewModel.generateQRCode()
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
				.font(.calloutRegular16)
                .foregroundColor(viewModel.resources.textColor)
				.padding(.horizontal, 16)

            viewModel.resources.copy
                .foregroundColor(viewModel.resources.titleColor)
				.padding(.trailing, 8)
				.onTapGesture {
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
                        .font(.subheadlineMedium15)
                        .frame(height: 22)
                    Text(String(viewModel.address.coinAmount) + " \(viewModel.address.result.currency)")
                        .font(.caption1Regular12)
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
                .font(.bodySemibold17)
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
    
    // MARK: - Private Methods
        
        @ToolbarContentBuilder
        private func createToolBar() -> some ToolbarContent {
            ToolbarItem(placement: .principal) {
                Text(viewModel.resources.tokenInfoTitle)
                    .font(.bodySemibold17)
                    .foregroundColor(.chineseBlack)
            }
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    R.image.navigation.backButton.image
                }
            }
        }

}
