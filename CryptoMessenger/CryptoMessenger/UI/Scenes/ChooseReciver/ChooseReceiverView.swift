import Combine
import SwiftUI

// MARK: - ChooseReceiverView

struct ChooseReceiverView: View {

    // MARK: - Internal Properties

    @Binding var receiverData: UserReceiverData
    @StateObject var viewModel: ChooseReceiverViewModel
    @State var searchText = ""
    @State var searching = false
    @FocusState private var inputViewIsFocused: Bool
    @Environment(\.presentationMode) private var presentationMode

    // MARK: - Private Properties

    private var scannedCodePublisher: AnyPublisher<String, Never> {
        Just(searchText).eraseToAnyPublisher()
    }

    // MARK: - Body

    var body: some View {
        content
            .hideKeyboardOnTap()
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text(R.string.localizable.chooseReceiverTitle())
                        .font(.system(size: 17, weight: .semibold))
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        viewModel.send(.onScanner(scannedScreen: $searchText))
                        viewModel.searchType = .wallet
                    } label: {
                        viewModel.sources.qrcode
                    }
                }
            }.onReceive(scannedCodePublisher) { code in
                if code.contains("ethereum") {
                    receiverData = UserReceiverData(name: receiverData.name,
                                                    url: receiverData.url,
                                                    adress: code.substring(fromIndex: 9),
                                                    walletType: receiverData.walletType)
                    searchText = code.substring(fromIndex: 9)
                } else if code.contains("bitcoin") {
                    receiverData = UserReceiverData(name: receiverData.name,
                                                    url: receiverData.url,
                                                    adress: code.substring(fromIndex: 8),
                                                    walletType: receiverData.walletType)
                } else if code.contains("binance") {
                    receiverData = UserReceiverData(name: receiverData.name,
                                                    url: receiverData.url,
                                                    adress: code.substring(fromIndex: 9),
                                                    walletType: receiverData.walletType)
                }
            }
            .onDisappear {
                if !searchText.isEmpty {
                    receiverData.adress = searchText
                }
            }
            .onChange(of: searchText) { newValue in
                viewModel.updateText(newValue)
            }
    }

    // MARK: - Private Properties

    private var content: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                searchSelectView
                    .padding(.top, 20)
                Divider()
                SearchBar(placeholder: viewModel.sources.countryCodePickerSearch,
                          searchText: $searchText,
                          searching: $searching)
                .focused($inputViewIsFocused)
                .padding(.top, 16)
                .padding(.bottom, 24)
                .padding(.horizontal, 16)
                .onTapGesture {
                    hideKeyboard()
                }
                .onSubmit {
                    if !searchText.isEmpty {
                        receiverData.adress = searchText
                    }
                    presentationMode.wrappedValue.dismiss()
                }
                if viewModel.isEnterAdressView {
                    if viewModel.searchType == .wallet {
                        EnterAdressUserView(adress: $searchText)
                            .listRowSeparator(.hidden)
                            .onTapGesture {
                                inputViewIsFocused = true
                            }
                    }
                }
                ForEach(
                    searchText.isEmpty ?
                    viewModel.userWalletsData : viewModel.userWalletsFilteredData,
                    id: \.self
                ) { item in
                    ContactRow(avatar: item.url,
                               name: item.name,
                               status: viewModel.searchType == .telephone ? item.phone :
                                viewModel.getAdress(item, receiverData),
                               isAdmin: false)
                    .listRowSeparator(.hidden)
                    .onTapGesture {
                        receiverData.name = item.name
                        receiverData.url = item.url
                        receiverData.adress = walletType(type: receiverData.walletType, item: item)
                        // receiverData.walletType == .ethereum ? item.ethereum : item.bitcoin
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                Spacer()
            }
        }
    }

    private func walletType(type: WalletType, item: UserWallletData) -> String {
        if type.rawValue.contains(WalletType.ethereum.rawValue) {
            return item.ethereum
        }

        if type.rawValue.contains(WalletType.bitcoin.rawValue) {
            return item.bitcoin
        }

        if type.rawValue.contains(WalletType.binance.rawValue) {
            return item.binance
        }

        // Добалена сеть которую мы не обрабатываем
        return ""
    }

    private var searchSelectView: some View {
        HStack(spacing: 0) {
            SearchTypeView(selectedSearchType: $viewModel.searchType,
                           searchTypeCell: SearchType.telephone )
            SearchTypeView(selectedSearchType: $viewModel.searchType,
                           searchTypeCell: SearchType.wallet )
        }
    }
}
