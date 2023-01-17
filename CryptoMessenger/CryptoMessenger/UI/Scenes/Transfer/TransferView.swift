import SwiftUI

// MARK: - TransferView

struct TransferView: View {

	// MARK: - Internal Properties

	@StateObject var viewModel: TransferViewModel
	@State var showCoinSelector = false
	@State var isSelectedWalletType = false
	@State var address: String = ""
	@State var receiverData: UserReceiverData = UserReceiverData(name: "",
																 url: URL(string: ""),
																 adress: "",
																 walletType: .ethereum)


	// MARK: - Body

	var body: some View {
		VStack(spacing: 0) {
			ScrollView {
				content
					.onTapGesture {
						hideKeyboard()
					}
					.onAppear {
						viewModel.send(.onAppear)
					}
					.navigationBarTitleDisplayMode(.inline)
					.navigationBarHidden(false)
					.toolbar {
						ToolbarItem(placement: .principal) {
							Text(R.string.localizable.transferTransfer())
								.font(.system(size: 17, weight: .semibold))
						}
					}
			}
			.scrollDismissesKeyboard(.interactively)

			sendButton
				.padding(.bottom)
				.popup(
					isPresented: viewModel.isSnackbarPresented,
					alignment: .bottom
				) { Snackbar(text: R.string.localizable.transferTransferError()) } 
		}
		.ignoresSafeArea(.keyboard)
	}

    // MARK: - Private Properties

    private var content: some View {
        VStack(alignment: .center, spacing: 24) {
            VStack(alignment: .leading, spacing: 0) {
                Text(R.string.localizable.transferYourAdress().uppercased())
					.font(.system(size: 12))
					.foregroundColor(.regentGrayApprox)
                    .padding(.leading, 16)
					.padding(.top, 16)
                addressCell
                    .background(.white())
                    .padding(.top, 14)
                    .padding(.horizontal, 16)

                Text(R.string.localizable.transferToWhom().uppercased())
					.font(.system(size: 12))
					.foregroundColor(.regentGrayApprox)
                    .padding(.leading, 16)
					.padding(.top, 32)
                chooseContactCell
                    .background(.white())
					.padding(.top, 14)
                    .padding(.horizontal, 16)
                    .onTapGesture {
                        viewModel.send(.onChooseReceiver($receiverData))
                    }
					.onChange(of: receiverData, perform: { data in
						viewModel.send(.onAddressChange(data.adress))
					})

                Text(R.string.localizable.transferSum().uppercased())
					.font(.system(size: 12))
					.foregroundColor(.regentGrayApprox)
                    .padding(.leading, 16)
					.padding(.top, 32)
                transferCell
					.frame(height: 47)
					.padding(.top, 8)
                    .padding(.horizontal, 16)
            }
			VStack(alignment: .center, spacing: 0) {
				TransactionSpeedSelectView(
					mode: .medium,
					transactionFees: viewModel.fees
				) { mode in
					viewModel.updateTransactionSpeed(item: mode)
				}
				.frame(height: 48)
			}
			.frame(height: 48)
			.padding([.top, .horizontal], 16)

            Spacer()
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
                    Text(viewModel.currentWallet.address)
						.font(.system(size: 17))
						.foregroundColor(.woodSmokeApprox)
                        .frame(height: 22)
						.lineLimit(1)
						.truncationMode(.middle)
                    Text(String(viewModel.currentWallet.coinAmount) + " \(viewModel.currentWallet.result.currency)")
						.font(.system(size: 12))
						.foregroundColor(.regentGrayApprox)
                        .frame(height: 20)
                }
            }
        }
    }

    private var chooseContactCell: some View {
        HStack(alignment: .center ) {
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(Color(.blue(0.1)))
                        .frame(width: 40, height: 40)
                    R.image.chat.action.contact.image
                }
                if receiverData.adress.isEmpty {
                    Text(R.string.localizable.transferChooseContact())
                        .font(.system(size: 17))
                        .foregroundColor(.woodSmokeApprox)
                        .frame(height: 22)
                } else {
                    Text(receiverData.adress)
                        .font(.system(size: 17))
                        .foregroundColor(.woodSmokeApprox)
                        .frame(height: 22)
                }
            }
            Spacer()
            R.image.profileDetail.arrow.image
                .frame(width: 20, height: 20, alignment: .center)
        }
    }

    private var transferCell: some View {
		HStack {
			VStack(alignment: .leading) {
				TextField("0.0", text: $viewModel.transferAmountProxy)
				.keyboardType(.decimalPad)
				.font(.system(size: 20))
				.foregroundColor(.woodSmokeApprox)
				.frame(maxWidth: .infinity, maxHeight: 47)

				Rectangle()
					.foregroundColor(.ironApprox)
					.frame(height: 1)
			}
			.frame(height: 47)
			.fixedSize(horizontal: false, vertical: true)

            Spacer()

			VStack(alignment: .trailing) {
				HStack(spacing: 12) {
					Text(viewModel.currentWallet.result.currency)
						.font(.system(size: 20))
						.foregroundColor(.woodSmokeApprox)
					R.image.answers.downsideArrow.image
						.foregroundColor(.woodSmokeApprox)
				}
				.frame(maxWidth: .infinity, maxHeight: .infinity)
				Rectangle()
					.foregroundColor(.ironApprox)
					.frame(height: 1)
			}
			.frame(height: 47)
			.fixedSize(horizontal: true, vertical: true)
			.onTapGesture {
				hideKeyboard()
				showCoinSelector = true
			}
        }
		.fixedSize(horizontal: false, vertical: true)
    }

    private var sendButton: some View {
        Button {
            viewModel.send(.onApprove)
        } label: {
            Text(R.string.localizable.walletSend())
				.font(.system(size: 17, weight: .semibold))
				.foregroundColor(.white)
                .padding()
				.frame(width: 237, height: 48)
				.background(
					Rectangle()
						.fill(
							viewModel.isTransferButtonEnabled ?
							Color.azureRadianceApprox : Color.cornflowerBlueApprox
						)
						.cornerRadius(8)
				)
        }
		.disabled(!viewModel.isTransferButtonEnabled)
		.frame(maxWidth: .infinity, idealHeight: 48)
    }
}
