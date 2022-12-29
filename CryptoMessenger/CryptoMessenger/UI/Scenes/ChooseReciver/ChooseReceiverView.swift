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
                        .font(.bold(15))
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        viewModel.send(.onScanner(scannedScreen: $searchText))
                        viewModel.searchType = .wallet
                    } label: {
                        R.image.chooseReceiver.qrcode.image
                    }
                }
            }.onReceive(scannedCodePublisher) { code in
                if code.contains("ethereum") {
                    receiverData = UserReceiverData(name: receiverData.name,
                                                    url: receiverData.url,
                                                    adress: code.substring(fromIndex: 9),
                                                    walletType: receiverData.walletType)
                } else if code.contains("bitcoin") {
                    receiverData = UserReceiverData(name: receiverData.name,
                                                    url: receiverData.url,
                                                    adress: code.substring(fromIndex: 8),
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
        VStack(spacing: 0) {
            searchSelectView
                .padding(.top, 20)
            Divider()
            SearchBar(placeholder: R.string.localizable.countryCodePickerSearch(),
                      searchText: $searchText,
                      searching: $searching)
                .focused($inputViewIsFocused)
                .padding(.top, 16)
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
            if viewModel.searchType == .wallet {
                EnterAdressUserView(adress: $searchText)
                    .listRowSeparator(.hidden)
                    .onTapGesture {
                        inputViewIsFocused = true
                    }
            }
            ForEach(searchText.isEmpty ? viewModel.userWalletsData :
                        viewModel.userWalletsFilteredData, id: \.self) { item in
                ContactRow(avatar: item.url,
                           name: item.name,
                           status: viewModel.searchType == .telephone ? item.phone : item.ethereum,
                           isAdmin: false)
                .listRowSeparator(.hidden)
                .onTapGesture {
                    receiverData.name = item.name
                    receiverData.url = item.url
                    receiverData.adress = receiverData.walletType == .ethereum ? item.ethereum : item.bitcoin
                    presentationMode.wrappedValue.dismiss()
                }
            }
            Spacer()

        }
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

struct EnterAdressUserView: View {

    // MARK: - Internal Properties

    @Binding var adress: String 

    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 12) {
                ZStack {
                    Color(.lightBlue())
                    Text("A")
                        .foreground(.white())
                        .font(.medium(22))
                }
                .scaledToFill()
                .frame(width: 40, height: 40)
                .cornerRadius(20)

                VStack(alignment: .leading, spacing: 4) {
                    HStack(spacing: 0) {
                        Text("Введите адресс")
                            .font(.semibold(15))
                            .foreground(.black())
                            .padding(.top, 12)
                    }
                    Text(adress)
                        .font(.regular(13))
                        .foreground(.darkGray())
                        .padding(.bottom, 12)
                }
                .frame(height: 64)
                Spacer()
            }
            .padding(.horizontal, 16)
        }
    }
}
