import SwiftUI

// MARK: - ChannelNotificaionsView

struct ChannelNotificaionsView: View {

    // MARK: - Internal Properties

    @StateObject var viewModel: ChannelNotificationsViewModel

    // MARK: - Private Properties

    @Environment(\.presentationMode) private var presentationMode

    // MARK: - Body

    var body: some View {
        List {
            Section {
                cellStatus
            } header: {
                Text("Всплывающие уведомления")
                    .font(.regular(12))
                    .foreground(.darkGray())
            }
            .listStyle(.insetGrouped)
        }
        .scrollDisabled(true)
        .toolbar(.visible, for: .navigationBar)
        .navigationBarTitle("", displayMode: .inline)
        .toolbar {
            createToolBar()
        }
    }

    // MARK: - Private Properties

    private var cellStatus: some View {
        ForEach(ChannelNotificationsStatus.allCases, id: \.self) { item in
            HStack {
                Text(item.rawValue)
                    .font(.regular(17))
                Spacer()
                R.image.channelSettings.checkmark.image
                    .frame(width: 14.3, height: 14.2)
                    .padding(.trailing, 15)
                    .opacity(viewModel.computeOpacity(item))
            }
            .background(.white())
            .onTapGesture {
                viewModel.updateNotifications(item)
            }
        }
    }

    // MARK: - Private methods

    @ToolbarContentBuilder
    private func createToolBar() -> some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
            Button(action: {
                presentationMode.wrappedValue.dismiss()
            }, label: {
                R.image.navigation.backButton.image
            })
        }
        ToolbarItem(placement: .principal) {
            Text("Уведомления")
                .font(.bold(17))
        }
    }
}
