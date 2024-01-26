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
        .navigationBarBackButtonHidden(true)
        .toolbar {
            createToolBar()
        }
    }

    // MARK: - Private Properties

    private var content: some View {
        List {
            if viewModel.isNotificationDevice {
                NotificationSettingsCell(field: $viewModel.userAccount)
                NotificationSettingsCell(field: $viewModel.onDevice)
            }
        }
        .listStyle(.insetGrouped)
        .scrollContentBackground(.hidden)
        .background(Color.ghostWhite.edgesIgnoringSafeArea(.all))
    }

    // MARK: - Private Methods

    @ToolbarContentBuilder
    private func createToolBar() -> some ToolbarContent {
        ToolbarItem(placement: .principal) {
            Text(viewModel.sources.additionalMenuNotification)
                .font(.bodySemibold17)
                .lineLimit(1)
        }
        ToolbarItem(placement: .navigationBarLeading) {
            Button {
                presentationMode.wrappedValue.dismiss()
            } label: {
                R.image.navigation.backButton.image
            }
        }
    }
}
