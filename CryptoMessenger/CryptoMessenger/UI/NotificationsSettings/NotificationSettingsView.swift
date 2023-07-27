import SwiftUI

// MARK: - NotificationSettingsView

struct NotificationSettingsView: View {

    // MARK: - Internal Properties

    @StateObject var viewModel: NotificationSettingsViewModel
    @Environment(\.presentationMode) private var presentationMode

    // MARK: - Body

    var body: some View {
        content
        .navigationBarHidden(false)
        .toolbar(.hidden, for: .tabBar)
        .toolbar {
            createToolBar()
        }
    }

    // MARK: - Private Properties

    private var content: some View {
        VStack(alignment: .leading, spacing: 16) {
            List {
                if viewModel.isNotificationDevice {
                    NotificationSettingsCell(field: $viewModel.userAccount)
                        .listRowSeparator(.hidden)
                    NotificationSettingsCell(field: $viewModel.onDevice)
                        .listRowSeparator(.hidden)
                }
            }
            .listRowSeparator(.hidden)
            .listStyle(.insetGrouped)
        }
    }

    // MARK: - Private Methods

    @ToolbarContentBuilder
    private func createToolBar() -> some ToolbarContent {
        ToolbarItem(placement: .principal) {
            Text(viewModel.sources.additionalMenuNotification)
                .font(.system(size: 15, weight: .bold))
                .lineLimit(1)
        }
    }

}
