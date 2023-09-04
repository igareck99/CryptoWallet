import SwiftUI

// MARK: - WalletView

struct WalletView: View {

    // MARK: - Internal Properties

    @StateObject var viewModel: WalletViewModel
    @State var contentWidth = CGFloat(0)
    @State var offset = CGFloat(16)
    @State var index = 0
    @State var showAddWallet = false
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
                viewModel.send(.onAppear)
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarHidden(false)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text(viewModel.resources.tabWallet)
                        .font(.system(size: 17, weight: .semibold))
                }
            }
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
                                        viewModel.onWalletCardTap(wallet: wallet)
                                    }
                                    .tag(index)
                                    .padding()
                            }
                        }
                        .tabViewStyle(.page(indexDisplayMode: .never))
                    }
                    .frame(minHeight: 220)
                
                cardsViews()
                
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
    func cardsViews() -> some View {
        HStack(spacing: 8) {
            ForEach(0..<viewModel.cardsList.count, id: \.self ) { value in
                if value == pageIndex {
                    RoundedRectangle(cornerRadius: 32)
                        .foregroundColor(.dodgerBlue)
                        .frame(width: 24, height: 8)
                }else {
                    Circle()
                        .frame(width: 8, height: 8)
                        .foregroundColor(.gainsboro)
                }
            }
        }
    }

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

            Text(viewModel.resources.walletNoData)
                .font(.system(size: 22))
                .foregroundColor(viewModel.resources.titleColor)
                .frame(alignment: .center)
                .padding(.bottom, 6)

            Text(viewModel.resources.walletAddWalletLong)
                .font(.system(size: 15))
                .foregroundColor(viewModel.resources.textColor)
                .frame(alignment: .center)
                .multilineTextAlignment(.center)
                .padding(.bottom, 70)

            Button {
                viewModel.showAddSeed()
            } label: {
                Text(viewModel.resources.walletAddWalletShort)
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(viewModel.resources.background)
                    .padding([.leading, .trailing], 40)
                    .padding([.bottom, .top], 13)
            }
            .background(viewModel.resources.buttonBackground)
            .cornerRadius(8)
            .frame(width: 237, height: 48)
        }
    }

    private var cardsProgressView: some View {
        ZStack(alignment: .leading) {
            Rectangle()
                .frame(height: 2)
                .foregroundColor(viewModel.resources.innactiveButtonBackground)
                .padding(.horizontal, 16)

            Rectangle()
                .frame(width: 111, height: 4)
                .foregroundColor(viewModel.resources.buttonBackground)
                .cornerRadius(2)
                .padding(.leading, offset)
        }
    }

    private var balanceView: some View {
        HStack(spacing: 12) {
            ZStack {
                Circle()
                    .frame(width: 60, height: 60)
                    .foregroundColor(viewModel.resources.avatarBackground)
                R.image.wallet.wallet.image
            }
            VStack(alignment: .leading, spacing: 8) {
                Text(viewModel.totalBalance)
                    .font(.system(size: 22, weight: .regular))
                Text(viewModel.resources.tabOverallBalance)
                    .font(.system(size: 13, weight: .regular))
                    .foregroundColor(viewModel.resources.innactiveButtonBackground)
            }
        }
    }

    private var transactionTitleView: some View {
        HStack {
            Text(viewModel.resources.walletTransaction)
                .font(.system(size: 16, weight: .semibold))
                .padding(.leading, 16)
            Spacer()
        }
        .frame(height: 21)
    }

    private var sendButton: some View {
        Button {
            viewModel.send(.onTransfer(walletIndex: pageIndex))
        } label: {
            Text(viewModel.resources.walletSend)
                .font(.system(size: 17, weight: .semibold))
                .frame(maxWidth: .infinity)
                .foregroundColor(viewModel.resources.background)
                .padding()
        }
        .background(viewModel.resources.buttonBackground)
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
            Text(viewModel.resources.walletNoData)
                .font(.system(size: 22))
                .foregroundColor(viewModel.resources.titleColor)
                .padding(.bottom, 4)
            Text(viewModel.resources.walletManagerMakeYourFirstTransaction)
                .multilineTextAlignment(.center)
                .font(.system(size: 15))
                .foregroundColor(viewModel.resources.textColor)

            Spacer()
                .frame(height: 60)
        }
    }
}
