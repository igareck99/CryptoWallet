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
                    Text(R.string.localizable.walletManagerKeyManager())
                        .font(.bold(15))
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
                   backgroundColor: Color(.black(0.3)),
                   view: {
                KeyListActionView(showActionSheet: $showActionSheet,
                                  viewModel: viewModel)
                    .frame(width: UIScreen.main.bounds.width,
                           height: 178, alignment: .center)
                    .background(.white())
                    .cornerRadius(16)
            }
            )
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
        self.viewModel.keysList.remove(atOffsets: indexSet)
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
                .paragraph(.init(lineHeightMultiple: 1.21, alignment: .left)),
                .font(.semibold(15)),
                .color(.black())
            ])
            Text(value.type, [
                .paragraph(.init(lineHeightMultiple: 1.16, alignment: .left)),
                .font(.regular(12)),
                .color(.darkGray())
            ])

        }
    }
}
