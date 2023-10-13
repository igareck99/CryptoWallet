import SwiftUI

// MARK: - GroupChatSelectContactView

struct GroupChatSelectContactView: View {

    // MARK: - Internal Properties

    @StateObject var viewModel: GroupChatSelectContactViewModel

    // MARK: - Private Properties

    @Environment(\.presentationMode) private var presentationMode

    var body: some View {
        VStack {
            ContactsForSendView(views: $viewModel.usersForCreate,
                                text: $viewModel.text)
            ScrollView(.vertical) {
                ForEach(viewModel.usersViews, id: \.id) { value in
                    Group {
                        value.view()
                            .frame(idealHeight: 64)
                        Divider().padding(.leading, 109)
                    }
                    .listRowSeparator(.hidden)
                }
            }
            .ignoresSafeArea()
            .listStyle(.inset)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar(.visible, for: .navigationBar)
            .toolbar {
                createToolBar()
            }

        }
        .navigationBarBackButtonHidden(true)
    }

    // MARK: - Private Methods

    @ToolbarContentBuilder
    private func createToolBar() -> some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
            Button(action: {
                presentationMode.wrappedValue.dismiss()
            }, label: {
                viewModel.resources.backImage
            })
        }
        ToolbarItem(placement: .principal) {
            Text(viewModel.resources.createActionGroupChat)
                .font(.bodySemibold17)
                .foregroundColor(viewModel.resources.titleColor)
        }
        ToolbarItem(placement: .navigationBarTrailing) {
            Button(action: {
                viewModel.onFinish()
            }, label: {
                Text(viewModel.resources.profileDetailRightButton)
                    .font(.bodyRegular17)
                    .foregroundColor(viewModel.getButtonColor())
            })
            .disabled(viewModel.isButtonAvailable)
        }
    }
}
