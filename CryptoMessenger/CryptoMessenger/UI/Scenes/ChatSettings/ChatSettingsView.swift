import SwiftUI

// MARK: - ChatSettingsView

struct ChatSettingsView: View {

    // MARK: - Internal Properties

    @StateObject var viewModel: ChatSettingsViewModel
    @State private var saveToPhotos = false

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
                                     currentState: $saveToPhotos)
                    .listRowSeparator(.hidden)
                    .onChange(of: saveToPhotos) { item in
                        if item {
                            print(saveToPhotos)
                        } else {
                            print(saveToPhotos)
                            // viewModel.updateIsBiometryOn(item: false)
                        }
                    }
            }
            .padding(.top, 16)
            Divider()
                VStack(alignment: .leading) {
                    Text(R.string.localizable.chatSettingsReserveCopy().uppercased())
                    .font(.bold(12))
                    .foreground(.darkGray())
                    ReserveCellView(text: R.string.localizable.chatSettingsReserveCopy())
                }
                .padding(.top, 8)
                Divider()
                    .padding(.top, 16)
                VStack(alignment: .leading, spacing: 40) {
                    ClearChatsCellView(title: R.string.localizable.chatSettingsClearAllChats())
                        .background(.white())
                        .onTapGesture {
                            print("clearChats")
                        }
                    ClearChatsCellView(title: R.string.localizable.chatSettingsDeleteAllChats())
                        .background(.white())
                        .onTapGesture {
                            print("deleteChats")
                        }
                }
        }
            .listRowSeparator(.hidden)
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

    // MARK: - Body

    var body: some View {
        HStack {
            Text(text)
                .font(.regular(15))
            Spacer()
            R.image.registration.arrow.image
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
