import SwiftUI

// MARK: - ChannelAddUserView

struct ChannelAddUserView: View {

    // MARK: - Private Properties

    @Environment(\.presentationMode) private var presentationMode
    @StateObject var viewModel: SelectContactViewModel
    @State private var pickedContacts: [Contact] = []

    // MARK: - Internal Properties

    var body: some View {
        VStack(alignment: .leading,
               spacing: 0) {
            Divider()
            HStack {
                Text(R.string.localizable.createChannelAdding())
                    .font(.system(size: 17, weight: .regular))
                    .padding(.leading, 16)
                    .foregroundColor(.romanSilver)
            }
            .frame(height: 44)
            Divider()
            content
                .padding(.top, 11)
        }
        .onAppear {
            viewModel.send(.onAppear)
        }
        .navigationBarTitle("", displayMode: .inline)
        .toolbar(.visible, for: .navigationBar)
        .toolbar {
            createToolBar()
        }
    }

    // MARK: - Private properties

    private var content: some View {
        List {
            ForEach(viewModel.usersViews, id: \.id) { value in
                value.view()
                    .frame(height: 64)
            }
            .listRowSeparator(.hidden)
        }
        .listStyle(.plain)
    }

    // MARK: - Private Methods

    @ToolbarContentBuilder
    private func createToolBar() -> some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
            Button(action: {
                pickedContacts = []
                presentationMode.wrappedValue.dismiss()
            }, label: {
                R.image.navigation.backButton.image
            })
        }
        ToolbarItem(placement: .principal) {
            Text(R.string.localizable.createChannelAllUsers())
                .font(.bodySemibold17)
                .lineLimit(1)
        }
        ToolbarItem(placement: .navigationBarTrailing) {
            Button(action: {
                viewModel.onFinish()
                presentationMode.wrappedValue.dismiss()
            }, label: {
                Text(R.string.localizable.profileDetailRightButton())
                    .font(.subheadlineMedium15)
                    .foregroundColor(.dodgerBlue)
            })
        }
    }
}
