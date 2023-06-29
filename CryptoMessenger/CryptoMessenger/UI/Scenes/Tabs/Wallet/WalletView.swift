import SwiftUI

// MARK: - WalletView

struct WalletView: View {

    // MARK: - Internal Properties

    @State var displayTransactionResult = false

    @StateObject var viewModel: WalletViewModel
    @StateObject var generateViewModel = GeneratePhraseViewModel()
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
    @State private var showAddWalletView = false

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
                displayTransactionResult = false
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
            .sheet(isPresented: $showAddWalletView, content: {
                GeneratePhraseView(
                    viewModel: generateViewModel,
                    showView: $showAddWalletView,
                    onSelect: { type in
                        switch type {
                        case .importKey:
                            viewModel.send(.onImportKey)
                            showAddWalletView = false
                        default:
                            break
                        }
                    }, onCreate: {
                        viewModel.send(.onAppear)
                    })
                .onDisappear {
                    generateViewModel.generatePhraseState = .generate
                }
            })
    }

    @State private var scrollViewContentOffset = CGFloat(0)

    var content: some View {
        GeometryReader { outsideProxy in
            ScrollView {
                
                    VStack(alignment: .leading, spacing: 16) {
                        TabView(selection: $pageIndex) {
                            ForEach(Array(viewModel.cardsList.enumerated()), id: \.element) { index, wallet in
                                WalletCardView(wallet: wallet)
                                    .onTapGesture {
                                        guard let item = viewModel.cardsList.first(where: { $0.address == wallet.address }) else { return }
                                        selectedAddress = item
                                        showTokenInfo = true
                                    }
                                    .tag(index)
                                    .padding()
                            }
                        }
                        .tabViewStyle(.page(indexDisplayMode: .never))
                    }
                    .frame(minHeight: 220)
                    NavigationLink(
                        destination: tokenInfoView(),
                        isActive: $showTokenInfo
                    ) { EmptyView() }

                sendButton
                    .padding(.horizontal, 16)

                transactionTitleView
                    .padding(.top, 24)

                    if viewModel.transactionsList(index: pageIndex).isEmpty {
                        emptyTransactionsView
                            .padding(.top, 32)
                    } else {
                        transactionView
                            .padding(.top, 8)
                            .background(
                                GeometryReader { insideProxy in
                                    let offset = calculateContentOffset(
                                        fromOutsideProxy: outsideProxy,
                                        insideProxy: insideProxy
                                    )
                                    Color.clear.preference(
                                        key: ScrollViewOffsetPreferenceKey.self,
                                        value: offset
                                    )
                                }
                            )
                    }
            }
            .coordinateSpace(name: "scroll")
            .onPreferenceChange(ScrollViewOffsetPreferenceKey.self) { value in
                scrollViewContentOffset = value
            }
            .onChange(of: scrollViewContentOffset) { newValue in
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
            .popup(isPresented: $showAddWallet,
                   type: .toast,
                   position: .bottom,
                   closeOnTap: false,
                   closeOnTapOutside: true,
                   backgroundColor: .chineseBlack04,
                   view: {
                AddWalletView(viewModel: viewModel,
                              showAddWallet: $showAddWallet)
                .frame(width: UIScreen.main.bounds.width,
                       height: 114,
                       alignment: .center)
                .background(.white)
                .cornerRadius(16)
            })
            .sheet(isPresented: $displayTransactionResult) {
                if let sentTransaction = viewModel.transaction {
                    TransactionResultView(model: sentTransaction)
                        .presentationDetents([.height(302)])
                }
            }
        }
    }

    private func calculateContentOffset(
        fromOutsideProxy outsideProxy: GeometryProxy,
        insideProxy: GeometryProxy
    ) -> CGFloat {
        return outsideProxy.frame(in: .named("scroll")).minY - insideProxy.frame(in: .named("scroll")).minY
    }

    // MARK: - Private Properties

    @ViewBuilder
    private func loadingStateView() -> some View {
        VStack {
            R.image.wallet.loader.image
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
                .foregroundColor(.chineseBlack)
                .frame(alignment: .center)
                .padding(.bottom, 6)

            Text(R.string.localizable.walletAddWalletLong())
                .font(.system(size: 15))
                .foregroundColor(.romanSilver)
                .frame(alignment: .center)
                .multilineTextAlignment(.center)
                .padding(.bottom, 70)

            Button {
                showAddWalletView = true
            } label: {
                Text(R.string.localizable.walletAddWalletShort())
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(.white)
                    .padding([.leading, .trailing], 40)
                    .padding([.bottom, .top], 13)
            }
            .background(Color.dodgerBlue)
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
                      )
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
        .background(.white)
    }

    private var cardsProgressView: some View {
        ZStack(alignment: .leading) {
            Rectangle()
                .frame(height: 2)
                .foregroundColor(.brightGray)
                .padding(.horizontal, 16)

            Rectangle()
                .frame(width: 111, height: 4)
                .foregroundColor(.dodgerBlue)
                .cornerRadius(2)
                .padding(.leading, offset)
        }
    }

    private var balanceView: some View {
        HStack(spacing: 12) {
            ZStack {
                Circle()
                    .frame(width: 60, height: 60)
                    .foregroundColor(.dodgerTransBlue)
                R.image.wallet.wallet.image
            }
            VStack(alignment: .leading, spacing: 8) {
                Text(viewModel.totalBalance)
                    .font(.regular(22))
                Text(R.string.localizable.tabOverallBalance())
                    .font(.regular(13))
                    .foregroundColor(.brightGray)
            }
        }
    }

    private var transactionTitleView: some View {
        HStack {
            Text(R.string.localizable.walletTransaction())
                .font(.system(size: 16, weight: .semibold))
                .padding(.leading, 16)
            Spacer()
        }
        .frame(height: 21)
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
            Text(R.string.localizable.walletSend())
                .font(.system(size: 17, weight: .semibold))
                .frame(maxWidth: .infinity)
                .foregroundColor(.white)
                .padding()
        }
        .background(Color.azureRadianceApprox)
        .frame(maxWidth: .infinity)
        .frame(height: 48)
        .cornerRadius(8)
    }

    private var transactionView: some View {
        VStack(spacing: 24) {
            LazyVStack(spacing: 0) {
                ForEach(viewModel.transactionsList(index: pageIndex), id: \.self) { item in
                    DisclosureGroup {
                        VStack(spacing: 0) {
                            TransactionDetailsView(model: item.details)
                                .padding(.horizontal, 16)
                            Divider()
                                .frame(maxWidth: .infinity)
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        // пока оставил, возможно придется вернуть
//                        .background(
//                            Color.alabasterSolid
//                                .frame(maxWidth: .infinity, maxHeight: .infinity)
//                                .padding(.top, -4)
//                        )
                    } label: {
                        VStack(spacing: 0) {
                            TransactionInfoView(transaction: item.info)
                                .padding(.leading, 16)
                            Divider()
                                .frame(maxWidth: .infinity)
                                .padding(.trailing, -20)
                                .padding(.leading, 66)
                                .padding(.top, 12)
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.plain)
                    .accentColor(.clear)
                }
            }
        }
    }

    private var emptyTransactionsView: some View {
        VStack(alignment: .center, spacing: 0) {
            R.image.wallet.emptyTransactions.image
                .padding(.bottom, 4)
            Text(R.string.localizable.walletNoData())
                .font(.system(size: 22))
                .foregroundColor(.chineseBlack)
                .padding(.bottom, 4)
            Text(R.string.localizable.walletManagerMakeYourFirstTransaction())
                .multilineTextAlignment(.center)
                .font(.system(size: 15))
                .foregroundColor(.romanSilver)

            Spacer()
                .frame(height: 60)
        }
    }
}
