import Combine
import SwiftUI

// MARK: - ChooseReceiverView

struct ChooseReceiverView: View {

    // MARK: - Internal Properties

    @StateObject var viewModel: ChooseReceiverViewModel
    @State var searchType = SearchType.contact
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
                    } label: {
                        R.image.chooseReceiver.qrcode.image
                    }
                }
            }.onReceive(scannedCodePublisher) { code in
                debugPrint(code)
            }
    }

    // MARK: - Private Properties

    private var content: some View {
        VStack(spacing: 1) {
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
            Spacer()

        }
    }

    private var searchSelectView: some View {
        HStack(spacing: 16) {
            SearchTypeView(selectedSearchType: $searchType,
                           searchTypeCell: SearchType.contact )
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
        VStack(spacing: 7) {
            Text(searchTypeCell.result,
                 [
                    .paragraph(.init(lineHeightMultiple: 1.15, alignment: .center)),
                    .font(.regular(13)),
                    .color(searchTypeCell == selectedSearchType ? .blue(): .darkGray())
                 ])
            Divider()
                .frame(height: 2)
                .background(.blue())
                .opacity(searchTypeCell == selectedSearchType ? 1 : 0)
        }
        .frame(minWidth: 53,
               maxWidth: 61,
               alignment: .center)
        .onTapGesture {
            selectedSearchType = searchTypeCell
        }
    }
}
