import Combine
import SwiftUI

// MARK: - ChooseReceiverView

struct ChooseReceiverView: View {

    // MARK: - Internal Properties

    @Binding var address: String
    @StateObject var viewModel: ChooseReceiverViewModel
    @State var searchType = SearchType.telephone
    @State var searchText = ""
    @State var searching = false

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
                        searchType = .wallet
                    } label: {
                        R.image.chooseReceiver.qrcode.image
                    }
                }
            }.onReceive(scannedCodePublisher) { code in
                debugPrint(code)
                if code.contains("ethereum") {
                    address = code.substring(fromIndex: 9)
                }
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
                .padding(.top, 16)
                .padding(.horizontal, 16)
                .onTapGesture {
                    hideKeyboard()
                }
            ForEach(viewModel.userWalletsData, id: \.self) { item in
                ContactRow(avatar: item.url,
                           name: item.name,
                           status: searchType == .telephone ? item.phone : item.ethereum ,
                           isAdmin: false)
            }
            Spacer()

        }
    }

    private var searchSelectView: some View {
        HStack(spacing: 0) {
            SearchTypeView(selectedSearchType: $searchType,
                           searchTypeCell: SearchType.telephone )
            SearchTypeView(selectedSearchType: $searchType,
                           searchTypeCell: SearchType.wallet )
        }
    }
}

// MARK: - SearchTypeView

struct SearchTypeView: View {

    // MARK: - Internal Properties

    @Binding var selectedSearchType: SearchType
    @State var searchTypeCell: SearchType

    // MARK: - Body

    var body: some View {
        VStack(alignment: .center, spacing: 7) {
            Text(searchTypeCell.result,
                 [
                    .paragraph(.init(lineHeightMultiple: 1.21, alignment: .center)),
                    .font(.regular(16)),
                    .color(searchTypeCell == selectedSearchType ? .blue(): .darkGray())
                 ])
            Divider()
                .frame(width: UIScreen.main.bounds.width / 2, height: 2)
                .background(.blue())
                .opacity(searchTypeCell == selectedSearchType ? 1 : 0)
        } 
        .onTapGesture {
            withAnimation(.easeOut(duration: 0.3)) {
                selectedSearchType = searchTypeCell
            }
        }
    }
}
