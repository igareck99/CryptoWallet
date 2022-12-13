import SwiftUI

// MARK: - TransferView

struct TransferView: View {

    // MARK: - Internal Properties

    @StateObject var viewModel: TransferViewModel
    @State var dollarCourse = 120.24
    @State var isButtonActive = true
    @State var isContactChoose = true
    @State var showCoinSelector = false
    @State var isSelectedWalletType = false
    @State var value = 0
    @State var address: String = ""

    // MARK: - Body

    var body: some View {
        content
			.onTapGesture {
                hideKeyboard()
            }
            .onAppear {
                viewModel.send(.onAppear)
            }
        .popup(isPresented: $showCoinSelector,
               type: .toast,
               position: .bottom,
               closeOnTap: false,
               closeOnTapOutside: true,
               backgroundColor: Color(.black(0.3))) {
			ChooseWalletTypeView(
				chooseWalletShow: $showCoinSelector,
				choosedWalletType: $viewModel.currentWalletType,
				isSelectedWalletType: $isSelectedWalletType,
				wallletTypes: viewModel.walletTypes
			)
                .frame(width: UIScreen.main.bounds.width, height: 242, alignment: .center)
                .background(.white())
                .cornerRadius(16)
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

    // MARK: - Private Properties

    private var content: some View {
        VStack(alignment: .center, spacing: 24) {
            Divider()
                .padding(.top, 8)
            VStack(alignment: .leading, spacing: 12) {
                Text(R.string.localizable.transferYourAdress().uppercased())
					.font(.system(size: 12))
					.foregroundColor(.regentGrayApprox)
                    .padding(.leading, 16)
                addressCell
                    .background(.white())
                    .padding(.top, 11)
                    .padding(.horizontal, 16)
            }
            VStack(alignment: .leading, spacing: 12) {
                Text(R.string.localizable.transferToWhom().uppercased())
					.font(.system(size: 12))
					.foregroundColor(.regentGrayApprox)
                    .padding(.leading, 16)
                chooseContactCell
                    .background(.white())
                    .padding(.horizontal, 16)
                    .onTapGesture {
                        viewModel.send(.onChooseReceiver($address))
                    }
            }
            .padding(.top, 4)
            VStack(alignment: .leading, spacing: 21) {
                Text(R.string.localizable.transferSum().uppercased())
					.font(.system(size: 12))
					.foregroundColor(.regentGrayApprox)
                    .padding(.leading, 16)
                transferCell
					.frame(height: 47)
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
			.padding(.horizontal, 16)

            Spacer()
			sendButton
				.frame(width: 237, height: 48)
				.padding(.bottom, 44)
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
                if address.isEmpty {
                    Text(R.string.localizable.transferChooseContact())
                        .font(.system(size: 17))
                        .foregroundColor(.woodSmokeApprox)
                        .frame(height: 22)
                } else {
                    Text(address)
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
                .frame(minWidth: 0, maxWidth: 214)
                .font(.semibold(15))
                .padding()
                .foregroundColor(.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.white, lineWidth: 2)
                )
        }
        .background(Color.azureRadianceApprox)
        .cornerRadius(10)
    }
}
