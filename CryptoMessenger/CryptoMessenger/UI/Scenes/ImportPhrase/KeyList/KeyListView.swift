import SwiftUI

// MARK: - KeyListView

struct KeyListView: View {

    // MARK: - Internal Properties

    @StateObject var viewModel: KeyListViewModel
    @State var showActionSheet = false

    // MARK: - Body

    var body: some View {
        content
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text(viewModel.resources.walletManagerKeyManager)
                        .font(.system(size: 15, weight: .bold))
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    R.image.chat.plus.image
                        .onTapGesture {
                            showActionSheet = true
                        }
                }
            }
            .popup(isPresented: $showActionSheet,
                   type: .toast,
                   position: .bottom,
                   closeOnTap: false,
                   closeOnTapOutside: true,
                   backgroundColor: viewModel.resources.backgroundFodding,
                   view: {
                KeyListActionView(showActionSheet: $showActionSheet,
                                  viewModel: viewModel)
                .frame(width: UIScreen.main.bounds.width,
                       height: 178, alignment: .center)
                .background(viewModel.resources.background)
                .cornerRadius(16)
            })
    }

    // MARK: - Private Properties

    private var content: some View {
        VStack {
            Divider()
                .padding(.top, 16)
            List {
                ForEach(viewModel.keysList, id: \.self) { item in
                    KeyValueTypeView(value: item)
                        .listRowSeparator(.hidden)
                }
                .onDelete(perform: self.deleteItem)
            }
            .listStyle(.inset)
            .padding(.top, 24)
        }
    }

    // MARK: - Private Methods

    private func deleteItem(at indexSet: IndexSet) {
        viewModel.keysList.remove(atOffsets: indexSet)
    }
}

// MARK: - KeyValueTypeView

struct KeyValueTypeView: View {

    // MARK: - Internal Properties
    @State var value: KeyValueTypeItem

    // MARK: - Body

    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(value.value, [
                .paragraph(.init(lineHeightMultiple: 1.21, alignment: .left))
            ])
            .font(.system(size: 15, weight: .semibold))
            .foregroundColor(.chineseBlack)
            Text(value.type, [
                .paragraph(.init(lineHeightMultiple: 1.16, alignment: .left))
            ])
            .font(.system(size: 12, weight: .regular))
            .foregroundColor(.romanSilver)

        }
    }
}
