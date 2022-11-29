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
        .toolbar {
            createToolBar()
        }
    }

    // MARK: - Private Properties

    private var content: some View {
        VStack(alignment: .leading, spacing: 16) {
            Divider()
            List {
                if viewModel.isNotificationMessages {
                    Section {
                        NotificationSettingsCell(field: $viewModel.messageNotification)
                            .listRowSeparator(.hidden)
                        NotificationSettingsCell(field: $viewModel.messagePriority)
                            .listRowSeparator(.hidden)
                    } header: {
                        Text("Сообщения")
                    }
                    .listSectionSeparator(.hidden, edges: [.top])
                    .listSectionSeparator(.visible, edges: [.bottom])
                }
                if viewModel.isNotificationGroup {
                    Section {
                        NotificationSettingsCell(field: $viewModel.groupNotification)
                            .listRowSeparator(.hidden)
                        NotificationSettingsCell(field: $viewModel.groupPriority)
                            .listRowSeparator(.hidden)
                    } header: {
                        Text("Группы")
                    }
                    .listSectionSeparator(.hidden, edges: [.top])
                    .listSectionSeparator(.visible, edges: [.bottom])
                }
                if viewModel.isNotificationSettings {
                    Section {
                        NotificationSettingsCell(field: $viewModel.parametersMessage)
                            .listRowSeparator(.hidden)
                        NotificationSettingsCell(field: $viewModel.parametersCalls)
                            .listRowSeparator(.hidden)
                    } header: {
                        Text("Параметры")
                            .listRowSeparator(.hidden)
                    }
                    .listSectionSeparator(.hidden, edges: [.top])
                    .listSectionSeparator(.visible, edges: [.bottom])
                }
                if viewModel.isNotificationsReset {
                    Text("Сбросить настройки уведомлений")
                        .font(.regular(15))
                        .foreground(.red())
                        .padding(.top, 16)
                        .listRowSeparator(.hidden)
                }
            }
            .listRowSeparator(.hidden)
            .listStyle(.plain)
        }
    }

    // MARK: - Private Methods

    @ToolbarContentBuilder
    private func createToolBar() -> some ToolbarContent {
        ToolbarItem(placement: .principal) {
            Text(R.string.localizable.additionalMenuNotification())
                .font(.bold(15))
                .lineLimit(1)
        }
    }

}
