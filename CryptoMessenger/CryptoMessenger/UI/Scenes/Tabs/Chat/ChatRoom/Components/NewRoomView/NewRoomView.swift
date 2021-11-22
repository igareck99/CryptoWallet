import MatrixSDK
import SwiftUI

// MARK: - NewRoomView

struct NewRoomView: View {
    @StateObject var mxStore: MatrixStore
    @Binding var createdRoomId: ObjectIdentifier?

    var body: some View {
        NewConversationView(store: mxStore, createdRoomId: $createdRoomId)
    }
}

private struct NewConversationView: View {
    @Environment(\.presentationMode) private var presentationMode

    let store: MatrixStore?
    @Binding var createdRoomId: ObjectIdentifier?

    @State private var users = ["@maxi:matrix.aura.ms"]
    @State private var editMode = EditMode.inactive
    @State private var roomName = ""
    @State private var isPublic = false

    @State private var isWaiting = false
    @State private var errorInfo: ErrorInfo?

    struct ErrorInfo: Identifiable {
        let id = UUID()
        let text: String
    }

    private var usersFooter: some View {
        Text("For example @username:matrix.aura.ms")
    }

    private var form: some View {
        Form {
            Section(footer: usersFooter) {
                ForEach(0..<users.count, id: \.self) { index in
                    HStack {
                        TextField("Matrix ID",
                                  text: Binding(get: { users[index] }, set: { users[index] = $0 }))
                            .disableAutocorrection(true)
                            .autocapitalization(.none)
                        Spacer()
                        Button(action: addUser) {
                            Image(systemName: "plus.circle")
                        }
                        .buttonStyle(BorderlessButtonStyle())
                        .disabled(users.contains(""))
                        .opacity(index == users.count - 1 ? 1.0 : 0.0)
                    }
                }
                .onDelete { users.remove(atOffsets: $0) }
                .deleteDisabled(users.count == 1)
            }

            if users.count > 1 {
                Section {
                    TextField("Название комнаты", text: $roomName)
                    Toggle("Публичная комната", isOn: $isPublic)
                }
            }

            Section {
                ZStack {
                    ScalableButtonView(
                        title: "Начать чат",
                        isDisabled: users.contains("") || (roomName.isEmpty && users.count > 1),
                        didTap: { createRoom() }
                    ).opacity(isWaiting ? 0 : 1)

                    if isWaiting {
                        ZStack {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                        }
                        .background(.clear)
                    }
                }
            }
            .alert(item: $errorInfo) { info in
                    Alert(
                        title: Text("Не удалось создать чат"),
                        message: Text(info.text)
                    )
            }
        }
    }

    var body: some View {
        NavigationView {
          form
            .environment(\.editMode, $editMode)
            .onChange(of: users.count) { count in
                editMode = count > 1 ? editMode : .inactive
            }
            .disabled(isWaiting)
            .navigationTitle(users.count > 1 ? "Новая комната" : "Новый чат")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Отменить") {
                        presentationMode.wrappedValue.dismiss()
                    }.foreground(.blue())
                }
                ToolbarItem(placement: .automatic) {
                    if users.count > 1 {
                        Button(editMode.isEditing
                                ? "Готово"
                                : "Редактировать"
                        ) {
                            editMode = editMode.isEditing ? .inactive : .active
                        }
                        .foreground(.blue())
                    }
                }
            }
        }
    }

    private func addUser() {
        withAnimation {
            users.append("")
        }
    }

    private func createRoom() {
        isWaiting = true

        let parameters = MXRoomCreationParameters()
        if users.count == 1 {
            parameters.inviteArray = users
            parameters.isDirect = true
            parameters.visibility = MXRoomDirectoryVisibility.private.identifier
            parameters.preset = MXRoomPreset.trustedPrivateChat.identifier
        } else {
            parameters.inviteArray = users
            parameters.isDirect = false
            parameters.name = roomName
            if isPublic {
                parameters.visibility = MXRoomDirectoryVisibility.public.identifier
                parameters.preset = MXRoomPreset.publicChat.identifier
            } else {
                parameters.visibility = MXRoomDirectoryVisibility.private.identifier
                parameters.preset = MXRoomPreset.privateChat.identifier
            }
        }

        store?.createRoom(parameters: parameters) { response in
            switch response {
            case .success(let room):
                createdRoomId = room.id
                presentationMode.wrappedValue.dismiss()
            case.failure(let error):
                errorInfo = ErrorInfo(text: error.localizedDescription)
                isWaiting = false
            }
        }
    }
}
