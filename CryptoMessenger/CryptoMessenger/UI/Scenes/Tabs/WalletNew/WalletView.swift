import SwiftUI

// MARK: - WalletView

struct WalletView: View {

    // MARK: - Internal Properties

    @StateObject var viewModel: WalletViewModel
    @State var contentWidth = CGFloat(0)
    @State var offset = CGFloat(16)
    @State var index = 0
    @State var showAddWallet = false
    @State var showTokenInfo = false
    @State var navBarHide = false
    @State var selectedAddress = WalletInfo(
        walletType: .ethereum,
        address: "0xty9 ... Bx9M",
        coinAmount: "1.012",
        fiatAmount: "33"
    )

    // MARK: - Body
	var body: some View {
		content
			.emptyState(
				viewState: viewModel.viewState,
				emptyContent: {
					emptyStateView()
				}, loadingContent: {
					loadingStateView()
				})
			.onAppear {
				debugPrint("onAppear")
				navBarHide = false
				showTabBar()
				viewModel.send(.onAppear)
			}
			.navigationBarTitleDisplayMode(.inline)
			.navigationBarHidden(false)
			.toolbar {
				ToolbarItem(placement: .principal) {
					Text(R.string.localizable.tabWallet())
						.font(.system(size: 17, weight: .semibold))
				}
			}
	}

    var content: some View {
        ScrollView(.vertical) {
            VStack(alignment: .leading, spacing: 16) {

                SlideCardsView(cards: viewModel.cardsList, onOffsetChanged: { off in
                    let cardWidth = CGFloat(343)
                    let cardsCount = viewModel.cardsList.count
                    let delta = cardsCount > 1 ? (cardsCount - 1) * 8 : 0
                    let contentWidth = cardsCount > 1
                    ? CGFloat((cardsCount - 1) * Int(cardWidth) + delta)
                    : cardWidth

                    let percent = off / contentWidth

                    withAnimation(.linear(duration: 0.2)) {
                        if percent <= 0 {
                            offset = 16
                        } else if percent >= 0.65 {
                            offset = cardWidth - 111 + 32
                        } else {
                            offset = cardWidth * percent
                        }
                    }
                }, onAddressSend: { _, address in
                    guard let item = viewModel.cardsList.first(where: { $0.address == address }) else { return }
                    selectedAddress = item
                    showTokenInfo = true
                }).padding(.top, 16)
            }

			NavigationLink(destination: tokenInfoView(), isActive: $showTokenInfo) { EmptyView() }

            VStack(spacing: 24) {
                cardsProgressView

                sendButton
                    .frame(height: 58)
                    .padding(.horizontal, 16)
                transactionTitleView
                    .padding(.top, 26)

                VStack(spacing: 0) {
                    ForEach(viewModel.transactionList) { item in
                        TransactionInfoView(transaction: item)
                            .padding(.horizontal, 16)
                            .padding(.top, 16)
                    }
                }
            }
            .padding(.top, 24)
        }
        .onChange(of: showAddWallet, perform: { value in
            if !value {
                showTabBar()
            }
        })
        .onChange(of: showTokenInfo, perform: { value in
            if !value {
                showTabBar()
            }
        })
        .onAppear {
//            viewModel.send(.onAppear)
        }
        .popup(isPresented: $showAddWallet,
               type: .toast,
               position: .bottom,
               closeOnTap: false,
               closeOnTapOutside: true,
               backgroundColor: Color(.black(0.3)),
               view: {
            AddWalletView(viewModel: viewModel,
                          showAddWallet: $showAddWallet)
                .frame(width: UIScreen.main.bounds.width,
                       height: 114, alignment: .center)
                .background(.white())
                .cornerRadius(16)
        })
    }

    // MARK: - Private Properties

	@State private var isRotating = 0.0
	
	@ViewBuilder
	private func loadingStateView() -> some View {
		VStack {
			Image(R.image.wallet.loader.name)
				.rotationEffect(.degrees(isRotating))
				.onAppear {
					withAnimation(.linear(duration: 1)
						.speed(0.4).repeatForever(autoreverses: false)) {
							isRotating = 360.0
						}
				}
		}
	}

	@ViewBuilder
	private func emptyStateView() -> some View {
		VStack(alignment: .center, spacing: 0) {

			Image(R.image.wallet.walletEmptyState.name)
				.frame(minHeight: 140)

			Text(R.string.localizable.walletNoData())
				.font(.system(size: 22))
				.foregroundColor(.tundoraApprox)
				.frame(alignment: .center)
				.padding(.bottom, 6)

			Text(R.string.localizable.walletAddWalletLong())
				.font(.system(size: 15))
				.foregroundColor(.nobelApprox)
				.frame(alignment: .center)
				.padding(.bottom, 70)

			Button {
				debugPrint("onImportKey")
				viewModel.send(.onImportPhrase)
			} label: {
				Text(R.string.localizable.walletAddWalletShort())
					.font(.system(size: 17, weight: .semibold))
					.foregroundColor(.white)
					.padding([.leading, .trailing], 40)
					.padding([.bottom, .top], 13)
			}
			.background(Color.azureRadianceApprox)
			.cornerRadius(8)
			.frame(width: 237, height: 48)
		}
	}

	private func tokenInfoView() -> some View {
		TokenInfoView(
			showTokenInfo: $showTokenInfo,
			viewModel: TokenInfoViewModel(
						address: selectedAddress,
						userCredentialsStorage: UserDefaultsService.shared
					  ),
			address: selectedAddress
		)
		.onAppear {
			hideTabBar()
			navBarHide = true
		}
		.frame(
			width: UIScreen.main.bounds.width,
			height: UIScreen.main.bounds.height - 60,
			alignment: .center
		)
		.background(.white())
	}

    private var cardsProgressView: some View {
        ZStack(alignment: .leading) {
            Rectangle()
                .frame(height: 2)
                .foreground(.grayE6EAED())
                .padding(.horizontal, 16)

            Rectangle()
                .frame(width: 111, height: 4)
                .foreground(.blue())
                .cornerRadius(2)
                .padding(.leading, offset)
        }
    }

    private var balanceView: some View {
        HStack(spacing: 12) {
            ZStack {
                Circle()
                    .frame(width: 60, height: 60)
                    .foreground(.lightBlue(0.1))
                R.image.wallet.wallet.image
            }
            VStack(alignment: .leading, spacing: 8) {
                Text(viewModel.totalBalance)
                    .font(.regular(22))
                Text(R.string.localizable.tabOverallBalance())
                    .font(.regular(13))
                    .foreground(.darkGray())
            }
        }
    }

    private var transactionTitleView: some View {
        HStack {
            Text(R.string.localizable.walletTransaction())
                .font(.medium(15))
                .padding(.leading, 16)
            Spacer()
            Button {
                viewModel.send(.onTransactionToken(selectorTokenIndex: -1))
            } label: {
                Text(R.string.localizable.walletAllTransaction())
                    .font(.regular(15))
                    .foreground(.blue())
                    .padding(.trailing, 16)
            }
        }
    }

    private var sendButton: some View {
        Button {
            viewModel.send(.onTransfer)
        } label: {
            Text(R.string.localizable.walletSend().uppercased())
                .frame(minWidth: 0, maxWidth: .infinity)
                .font(.semibold(14))
                .padding()
                .foregroundColor(.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 4)
                        .stroke(Color.white, lineWidth: 2)
                )
        }
        .background(Color.blue)
        .cornerRadius(4)
    }
}
