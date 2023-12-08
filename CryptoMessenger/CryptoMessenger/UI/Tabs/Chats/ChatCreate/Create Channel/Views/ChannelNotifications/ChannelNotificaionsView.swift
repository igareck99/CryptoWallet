import SwiftUI

// MARK: - ChannelNotificaionsView

struct ChannelNotificaionsView: View {

    // MARK: - Internal Properties

    @StateObject var viewModel: ChannelNotificationsViewModel

    // MARK: - Private Properties

    @Environment(\.presentationMode) private var presentationMode

    // MARK: - Body

    var body: some View {
        NavigationView {
            List {
                Section {
                    cellStatus
                } header: {
                    Text(viewModel.resouces.channelNotificationsPopUpAlerts)
                        .font(.caption1Regular12)
                        .foregroundColor(viewModel.resouces.textColor)
                }
                .listStyle(.insetGrouped)
            }
            .scrollDisabled(true)
            .toolbar(.visible, for: .navigationBar)
            .navigationBarTitle("", displayMode: .inline)
            .toolbar {
                createToolBar()}
            }
        }

    // MARK: - Private Properties

    private var cellStatus: some View {
        ForEach(ChannelNotificationsStatus.allCases, id: \.self) { item in
            HStack {
                Text(item.rawValue)
                    .font(.bodyRegular17)
                Spacer()
                viewModel.resouces.checkmarkImage
                    .frame(width: 14.3, height: 14.2)
                    .padding(.trailing, 15)
                    .opacity(viewModel.computeOpacity(item))
            }
            .background(viewModel.resouces.background)
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
                viewModel.resouces.backButtonImage
            })
        }
        ToolbarItem(placement: .principal) {
            Text(viewModel.resouces.channelNotificationsAlerts)
                .font(.bodySemibold17)
        }
    }
}
