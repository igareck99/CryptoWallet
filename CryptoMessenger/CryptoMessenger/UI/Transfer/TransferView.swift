import SwiftUI

// MARK: - TransferView

struct TransferView: View {

	// MARK: - Internal Properties

	@StateObject var viewModel: TransferViewModel
    @Environment(\.presentationMode) private var presentationMode
	@State var showCoinSelector = false
	@State var isSelectedWalletType = false
	@State var address: String = ""
    @State var sheetHeight: Double = 0


	// MARK: - Body
    // 69
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
                            wallletTypes: [viewModel.walletTypes[0],viewModel.walletTypes[1]]
                        )
                        .padding()
                        .overlay {
                            GeometryReader { geometry in
                                Color.clear.preference(key: InnerHeightPreferenceKey.self, value: geometry.size.height)
                            }
                        }
                        .onPreferenceChange(InnerHeightPreferenceKey.self) { newHeight in
                            sheetHeight = newHeight
                        }
                        .presentationDetents([.height(sheetHeight)])
                        .presentationDragIndicator(.visible)
                        
                    }
                    .navigationBarTitleDisplayMode(.inline)
                    .navigationBarBackButtonHidden(true)
                    .navigationBarHidden(false)
                    .toolbar {
                        createToolBar()
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
        .popup(
            isPresented: viewModel.isSnackbarPresented,
            alignment: .bottom
        ) {
            Snackbar(
                text: viewModel.messageText,
                color: .spanishCrimson
            )
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
                        viewModel.send(.onChooseReceiver)
                    }
                    .onChange(of: viewModel.receiverData, perform: { data in
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
                        .resizable()
                        .frame(width: 24, height: 24)
                }
                if viewModel.receiverData.adress.isEmpty {
                    Text(viewModel.resources.transferChooseContact)
                        .font(.bodyRegular17)
                        .foregroundColor(viewModel.resources.titleColor)
                        .frame(height: 22)
                } else {
                    Text(viewModel.receiverData.adress)
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
                    .foregroundColor(viewModel.resources.separatorColor)
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
                    viewModel.resources.chevronDown
				}
				.frame(maxWidth: .infinity, maxHeight: .infinity)
				Rectangle()
                    .foregroundColor(viewModel.resources.separatorColor)
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
                    !viewModel.isTransferButtonEnabled ?
                        .ashGray : .white
                )
                .padding()
				.frame(width: 237, height: 48)
				.background(
					Rectangle()
						.fill(
							!viewModel.isTransferButtonEnabled ?
                                Color.ghostWhite : Color.dodgerBlue
						)
						.cornerRadius(8)
				)
        }
		.disabled(!viewModel.isTransferButtonEnabled)
		.frame(maxWidth: .infinity, idealHeight: 48)
    }
    
    // MARK: - Private Methods
    
    @ToolbarContentBuilder
    private func createToolBar() -> some ToolbarContent {
        ToolbarItem(placement: .principal) {
            Text(viewModel.resources.transferTransfer)
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


struct InnerHeightPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = .zero
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}
