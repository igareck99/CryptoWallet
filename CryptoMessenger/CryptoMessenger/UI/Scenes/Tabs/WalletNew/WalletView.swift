import SwiftUI

// MARK: - WalletView

struct WalletView: View {

    // MARK: - Internal Properties

	@State var displayTransactionResult = false

    @StateObject var viewModel: WalletViewModel
    @State var contentWidth = CGFloat(0)
    @State var offset = CGFloat(16)
    @State var index = 0
    @State var showAddWallet = false
    @State var showTokenInfo = false
    @State var navBarHide = false
    @State var selectedAddress = WalletInfo(
		decimals: 1,
		walletType: .ethereum,
        address: "",
        coinAmount: "",
        fiatAmount: ""
    )

	@State var pageIndex: Int = 0
	@State private var isRotating = 0.0

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

	@State private var scrollViewContentOffset = CGFloat(0)

    var content: some View {
		TrackableScroll(
			.vertical,
			showIndicators: true,
			contentOffset: $scrollViewContentOffset
		) {
            VStack(alignment: .leading, spacing: 16) {
				TabView(selection: $pageIndex) {
					ForEach(Array(viewModel.cardsList.enumerated()), id: \.element) { index, wallet in
						CardNewView(wallet: wallet)
							.onTapGesture {
								guard let item = viewModel.cardsList.first(where: { $0.address == wallet.address }) else { return }
								selectedAddress = item
								showTokenInfo = true
							}
							.tag(index)
							.padding()
							.onChange(of: pageIndex, perform: { index in
								debugPrint("CURRENT PAGE INDEX: \(index)")
								debugPrint("CURRENT PAGE INDEX: \(pageIndex)")
							})
					}
				}
				.tabViewStyle(.page(indexDisplayMode: .never))
            }
			.frame(minHeight: 220)
			NavigationLink(
				destination: tokenInfoView(),
				isActive: $showTokenInfo
			) { EmptyView() }

            VStack(spacing: 24) {
				// пока убрал, надо сделать после имплементации основного функционала
//                cardsProgressView

                sendButton
                    .frame(height: 58)
                    .padding(.horizontal, 16)

				transactionTitleView
                    .padding(.top, 26)

                VStack(spacing: 0) {
					ForEach(viewModel.transactionsList(index: pageIndex)) { item in
						DisclosureGroup {
							TransactionDetailsView(model: item.details)
								.padding(.horizontal, 16)
						} label: {
							TransactionInfoView(transaction: item.info)
								.padding(.horizontal, 16)
						}
						.buttonStyle(.plain)
						.accentColor(.clear)
						.padding(.vertical, 4)
                    }
                }
            }
            .padding(.top, 24)
        }
		.onChange(of: scrollViewContentOffset) { newValue in
			debugPrint("TrackableScroll scrollViewContentOffset: \(newValue)")
			viewModel.tryToLoadNextTransactions(offset: newValue, pageIndex: pageIndex)
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
		.sheet(isPresented: $displayTransactionResult) {
			if let sentTransaction = viewModel.transaction {
				TransactionResultView(model: sentTransaction)
					.presentationDetents([.height(302)])
			}
		}
    }

    // MARK: - Private Properties

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
        }
    }

    private var sendButton: some View {
        Button {
			viewModel.send(.onTransfer(walletIndex: pageIndex))

			let onTransactionEndClosure: (TransactionResult) -> Void = {
				viewModel.transaction = $0
				displayTransactionResult = true
			}
			viewModel.onTransactionEnd = onTransactionEndClosure
			viewModel.onTransactionEndHelper(onTransactionEndClosure)
        } label: {
            Text(R.string.localizable.walletSend().uppercased())
                .frame(width: 237)
                .font(.semibold(14))
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
