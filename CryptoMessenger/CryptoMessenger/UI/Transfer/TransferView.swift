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
                    .sheet(isPresented: $showCoinSelector) {
                        ChooseWalletTypeView(
                            chooseWalletShow: $showCoinSelector,
                            choosedWalletType: $viewModel.currentWalletType,
                            isSelectedWalletType: $isSelectedWalletType,
                            wallletTypes: viewModel.walletTypes
                        )
                        .presentationDetents([.height(CGFloat(viewModel.walletTypes.count * 54 + 70))])
                        .presentationDragIndicator(.visible)
                    }
                    .navigationBarTitleDisplayMode(.inline)
                    .navigationBarHidden(false)
                    .toolbar {
                        ToolbarItem(placement: .principal) {
                            Text(viewModel.resources.transferTransfer)
								.font(.bodySemibold17)
						}
					}
			}
			.scrollDismissesKeyboard(.interactively)
            .toolbar(.hidden, for: .tabBar)

			sendButton
				.padding(.bottom)
				.popup(
					isPresented: viewModel.isSnackbarPresented,
					alignment: .bottom
                ) { Snackbar(text: viewModel.resources.transferTransferError) }
		}
		.ignoresSafeArea(.keyboard)
	}

    // MARK: - Private Properties

    private var content: some View {
        VStack(alignment: .center, spacing: 24) {
            VStack(alignment: .leading, spacing: 0) {
                Text(viewModel.resources.transferYourAdress.uppercased())
					.font(.caption1Regular12)
                    .foregroundColor(viewModel.resources.textColor)
                    .padding(.leading, 16)
					.padding(.top, 16)

                addressCell
                    .background(viewModel.resources.background)
                    .padding(.top, 14)
                    .padding(.horizontal, 16)

                Text(viewModel.resources.transferToWhom.uppercased())
					.font(.caption1Regular12)
                    .foregroundColor(viewModel.resources.textColor)
                    .padding(.leading, 16)
					.padding(.top, 32)
                
                chooseContactCell
                    .background(viewModel.resources.background)
					.padding(.top, 14)
                    .padding(.horizontal, 16)
                    .onTapGesture {
                        self.receiverData.walletType = viewModel.currentWallet.walletType
                        viewModel.send(.onChooseReceiver($receiverData))
                    }
					.onChange(of: receiverData, perform: { data in
						viewModel.send(.onAddressChange(data.adress))
					})

                Text(viewModel.resources.transferSum.uppercased())
					.font(.caption1Regular12)
                    .foregroundColor(viewModel.resources.textColor)
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
                        .fill(viewModel.resources.avatarBackground)
                        .frame(width: 40, height: 40)
                    R.image.chat.logo.image
                }
                VStack(alignment: .leading, spacing: 2) {
                    Text(viewModel.currentWallet.address)
						.font(.bodyRegular17)
                        .foregroundColor(viewModel.resources.titleColor)
                        .frame(height: 22)
						.lineLimit(1)
						.truncationMode(.middle)
                    Text(String(viewModel.currentWallet.coinAmount) + " \(viewModel.currentWallet.result.currency)")
						.font(.caption1Regular12)
                        .foregroundColor(viewModel.resources.textColor)
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
                        .fill(viewModel.resources.avatarBackground)
                        .frame(width: 40, height: 40)
                    viewModel.resources.contact
                }
                if receiverData.adress.isEmpty {
                    Text(viewModel.resources.transferChooseContact)
                        .font(.bodyRegular17)
                        .foregroundColor(viewModel.resources.titleColor)
                        .frame(height: 22)
                } else {
                    Text(receiverData.adress)
                        .font(.bodyRegular17)
                        .foregroundColor(viewModel.resources.titleColor)
                        .frame(height: 22)
                }
            }
            Spacer()

            R.image.transaction.chevronForward.image
        }
    }

    private var transferCell: some View {
		HStack {
			VStack(alignment: .leading) {
                TextField("0\(Locale.current.decimalSeparator ?? ",")0", text: $viewModel.transferAmountProxy)
                    .keyboardType(.decimalPad)
                    .font(.title3Regular20)
                    .foregroundColor(viewModel.resources.titleColor)
                    .frame(maxWidth: .infinity, maxHeight: 47)

				Rectangle()
                    .foregroundColor(viewModel.resources.textColor)
					.frame(height: 1)
			}
			.frame(height: 47)
			.fixedSize(horizontal: false, vertical: true)

            Spacer()

			VStack(alignment: .trailing) {
				HStack(spacing: 12) {
                    Text(viewModel.currentWallet.walletType.currency)
						.font(.title3Regular20)
						.foregroundColor(viewModel.resources.titleColor)
					R.image.answers.downsideArrow.image
						.foregroundColor(viewModel.resources.titleColor)
				}
				.frame(maxWidth: .infinity, maxHeight: .infinity)
				Rectangle()
                    .foregroundColor(viewModel.resources.titleColor)
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
            Text(viewModel.resources.walletSend)
				.font(.bodySemibold17)
				.foregroundColor(
                    viewModel.isTransferButtonEnabled ?
                    viewModel.resources.background : viewModel.resources.inactiveButtonTextColor
                )
                .padding()
				.frame(width: 237, height: 48)
				.background(
					Rectangle()
						.fill(
							viewModel.isTransferButtonEnabled ?
                            viewModel.resources.inactiveButtonBackground : viewModel.resources.buttonColor
						)
						.cornerRadius(8)
				)
        }
		.disabled(!viewModel.isTransferButtonEnabled)
		.frame(maxWidth: .infinity, idealHeight: 48)
    }
}
