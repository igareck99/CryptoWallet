import SwiftUI

// MARK: - ChatSettingsView

struct ChatSettingsView: View {

    // MARK: - Internal Properties

    @StateObject var viewModel: ChatSettingsViewModel
    @State private var saveToPhotos = false
    @State private var showChatsAlert = false
    @State private var alertType = AlertType.deleteChats

    // MARK: - Body

    var body: some View {
        Divider().padding(.top, 16)
        List {
            VStack(alignment: .leading, spacing: 16) {
            VStack(alignment: .leading, spacing: 8) {
                Text(R.string.localizable.chatSettingsMedia())
                    .font(.bold(12))
                    .foreground(.darkGray())
                    .listRowSeparator(.hidden)
                SaveToCameraCellView(title: R.string.localizable.chatSettingsSaveToPhotos(),
                                     description: R.string.localizable.chatSettingsSaveMediaToDevice(),
                                     currentState: $viewModel.saveToPhotos)
                    .listRowSeparator(.hidden)
                    .onChange(of: viewModel.saveToPhotos) { item in
                        viewModel.updateSaveToPhotos(item: item)
                    }
            }
            .padding(.top, 16)
            Divider()
                VStack(alignment: .leading) {
                    Text(R.string.localizable.chatSettingsReserveCopy().uppercased())
                    .font(.bold(12))
                    .foreground(.darkGray())
                    ReserveCellView(text: R.string.localizable.chatSettingsReserveCopy())
                        .background(.white())
                        .onTapGesture {
                            viewModel.send(.onReserveCopy)
                        }
                }
                .padding(.top, 8)
                Divider()
                    .padding(.top, 16)
                VStack(alignment: .leading, spacing: 40) {
                    ClearChatsCellView(title: R.string.localizable.chatSettingsClearAllChats())
                        .background(.white())
                        .onTapGesture {
                            showChatsAlert = true
                            alertType = .clearChats
                        }
                    ClearChatsCellView(title: R.string.localizable.chatSettingsDeleteAllChats())
                        .background(.white())
                        .onTapGesture {
                            showChatsAlert = true
                            alertType = .deleteChats
                        }
                }
        }
            .listRowSeparator(.hidden)
        }
        .navigationBarHidden(false)
        .onAppear {
            viewModel.send(.onAppear)
        }
        .onDisappear {
//            showTabBar()
        }
        .alert(isPresented: $showChatsAlert) { () -> Alert in
            switch alertType {
            case .deleteChats:
                let primaryButton = Alert.Button.default(Text(R.string.localizable.profileDetailDeleteAlertApprove())) {
                        viewModel.deleteChats()
                }
                let secondaryButton = Alert.Button.cancel(Text(R.string.localizable.profileDetailDeleteAlertCancel()))
                return Alert(title: Text(R.string.localizable.chatSettingsDeleteAlertTitle()),
                             message: Text(R.string.localizable.chatSettingsDeleteAlertText()),
                             primaryButton: primaryButton,
                             secondaryButton: secondaryButton)
            case .clearChats:
                let primaryButton = Alert.Button.default(Text(R.string.localizable.profileDetailDeleteAlertApprove())) {
                        viewModel.clearChats()
                }
                let secondaryButton = Alert.Button.cancel(Text(R.string.localizable.profileDetailDeleteAlertCancel()))
                return Alert(title: Text(R.string.localizable.chatSettingsClearAlertTitle()),
                             message: Text(R.string.localizable.chatSettingsClearAlertText()),
                             primaryButton: primaryButton,
                             secondaryButton: secondaryButton)
            }
        }
        .listStyle(.plain)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text(R.string.localizable.additionalMenuChats())
                    .font(.bold(15))
            }
        }
    }
}

// MARK: - ReserveCellView

struct ReserveCellView: View {

    // MARK: - Internal Properties

    var text: String
    @State var tapped = false

    // MARK: - Body

    var body: some View {
        HStack {
            Text(text)
                .font(.regular(15))
            Spacer()
            R.image.registration.arrow.image
                .opacity(tapped == true ? 0 : 1)
        }
    }
}

// MARK: - SaveToCameraCellView

struct SaveToCameraCellView: View {

    // MARK: - Internal Properties

    var title: String
    var description: String
    @Binding var currentState: Bool

    // MARK: - Body

    var body: some View {
        HStack(alignment: .center) {
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.regular(15))
                Text(description)
                    .font(.regular(12))
                    .foreground(.gray())
                    .padding(.top, 4)
            }
            Spacer()
            Toggle("", isOn: $currentState)
                .labelsHidden()
                .toggleStyle(SwitchToggleStyle(tint: .blue))
        }
    }
}

// MARK: - ClearChatsCellView

struct ClearChatsCellView: View {

    // MARK: - Internal Properties

    var title: String

    // MARK: - Body

    var body: some View {
        HStack {
            Text(title)
                .font(.regular(15))
                .foreground(.red())
            Spacer()
            Text("")
        }
    }
}
// MARK: - AlertType

enum AlertType {

    // MARK: - Internal Properties

    case clearChats
    case deleteChats
}
