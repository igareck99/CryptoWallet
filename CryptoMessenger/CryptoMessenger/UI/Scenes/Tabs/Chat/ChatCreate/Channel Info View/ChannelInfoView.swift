import SwiftUI

// MARK: - ChannelInfoView

struct ChannelInfoView<ViewModel: ChannelInfoViewModelProtocol>: View {

    // MARK: - Internal Properties

    @StateObject var viewModel: ViewModel

    // MARK: - Private Properties

    @Environment(\.presentationMode) private var presentationMode
    @State private var showNotificationsView = false
    @State private var showParticipantsView = false
    @State private var changeState = false
    @State private var showChannelChangeType = false
    @State private var showAddUser = false

    // TODO: - Test Parametrs

    @State private var nameText = "Встреча выпускников"
    @State private var description = "sasas"
    @State var textViewHeight: CGFloat = 120

    // MARK: - Body

    var body: some View {
        Group {
            if changeState {
                changeView
            } else {
                mainView
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(false)
        .navigationBarTitleDisplayMode(.inline)
        .navigationViewStyle(.stack)
        .listStyle(.insetGrouped)
        .toolbar {
            if changeState {
                createChangeToolBar()
            } else {
                createToolBar()
            }
        }
        .sheet(isPresented: $showNotificationsView, content: {
            NavigationView {
                ChannelNotificaionsView(viewModel: ChannelNotificationsViewModel())
            }
        })
        .sheet(isPresented: $showParticipantsView, content: {
            NavigationView {
                ChannelParticipantsView(viewModel: viewModel)
            }
        })
        .sheet(isPresented: $showChannelChangeType, content: {
            NavigationView {
                SelectChannelTypeView(showChannelChangeType: $showChannelChangeType)
            }
        })
        .sheet(isPresented: $showAddUser, content: {
            NavigationView {
                ChannelAddUserView()
            }
        })
        .popup(
            isPresented: viewModel.isSnackbarPresented,
            alignment: .bottom
        ) {
            Snackbar(
                text: "Ссылка скопирована",
                color: .green
            )
        }
        .onAppear {
            UITextView.appearance().background(.white())
        }
    }
    
    private var mainView: some View {
        List {
            Section {
                screenHaderView()
                    .frame(maxWidth: .infinity)
                    .listRowInsets(.none)
                    .listRowBackground(Color.clear)
            }
            Section {
                channelDescriptionView()
            }
            Section {
                attachmentsView()
                notificationsView()
            }
            Section {
                participantsHeader()
                    .listRowSeparator(.hidden)
                channelParticipantsView()
                participantsFooter()
                    .listRowSeparator(.hidden)
                    .frame(maxWidth: .infinity)
                    .listRowInsets(.none)
            }
            Section {
                copyLinkView()
                leaveChannelView()
            }
        }
    }
    
    private var changeView: some View {
        List {
            changeGroupInfoView
                .frame(maxWidth: .infinity)
                .listRowInsets(.none)
                .listRowBackground(Color.clear)
            Section {
                changeChannelTypeView()
                deleteChannelView()
            }
        }
        .listStyle(.insetGrouped)
    }
    
    // MARK: - Private Methods
    
    private func changeAvatarView() -> some View {
        ZStack(alignment: .center) {
            Circle()
                .foregroundColor(.cyan)
                .frame(width: 80, height: 80)
            ZStack(alignment: .center) {
                Circle()
                    .foregroundColor(.azureRadianceApprox)
                    .frame(width: 24, height: 24)
                R.image.profileDetail.camera.image
                    .resizable()
                    .frame(width: 10.5, height: 8.2)
            }
            .padding([.top, .leading], 56)
        }
    }
    
    private var changeGroupInfoView: some View {
        VStack(spacing: 10) {
            changeAvatarView()
            TextFieldChannelView(text: $nameText,
                                 placeholder: "")
            HStack {
                ResizeableTextView(
                    text: $description,
                    height: $textViewHeight,
                    placeholderText: ""
                )
                .background(.white())
                .frame(width: UIScreen.main.bounds.width - 32)
                .keyboardType(.default)
                .clipShape(RoundedRectangle(cornerRadius: 16,
                                            style: .continuous))
            }
            .padding(.horizontal, 16)
        }
    }

    private func screenHaderView() -> some View {
        VStack(alignment: .center, spacing: 0) {
            Spacer()
                .frame(height: 1)
            Circle()
                .foregroundColor(.cyan)
                .frame(width: 80, height: 80)
                .padding(.bottom, 16)
            Text("Встреча выпускников")
                .font(.system(size: 22))
                .foregroundColor(.black)
                .padding(.bottom, 4)
            
            Text("41 участник")
                .font(.system(size: 15))
                .foregroundColor(.regentGrayApprox)
        }
    }
    
    private func channelDescriptionView() -> some View {
        Text(
             """
             Каждую субботу собираемся и выпиваем, обсуждаем стартапы, делаем вид, что мы успешные, все по-классике.
             Всем быть веселыми!!!
             """
        )
        .font(.system(size: 17))
        .foregroundColor(.black)
    }
    
    private func attachmentsView() -> some View {
        ChannelSettingsView(
            title: "Вложения",
            imageName: "folder",
            accessoryImageName: "chevron.right"
        )
    }
    
    private func notificationsView() -> some View {
        ChannelSettingsView(
            title: "Уведомления",
            imageName: "bell",
            accessoryImageName: "chevron.right"
        )
        .onTapGesture {
            showNotificationsView = true
        }
    }
    
    private func copyLinkView() -> some View {
        ChannelSettingsView(
            title: "Скопировать ссылку",
            imageName: "doc.on.doc",
            accessoryImageName: ""
        )
        .onTapGesture {
            debugPrint("copy channel link")
            viewModel.onChannelLinkCopy()
        }
    }
    
    private func leaveChannelView() -> some View {
        ChannelSettingsView(
            title: "Покинуть канал",
            titleColor: .amaranthApprox,
            imageName: "rectangle.portrait.and.arrow.right",
            imageColor: .amaranthApprox,
            accessoryImageName: ""
        )
    }

    private func changeChannelTypeView() -> some View {
        ChannelSettingsView(
            title: "Тип канала",
            imageName: "megaphone",
            accessoryImageName: "",
            value: "Частный"
        )
        .onTapGesture {
            showChannelChangeType = true
        }
    }
    
    private func deleteChannelView() -> some View {
        ChannelSettingsView(
            title: "Удалить канал",
            titleColor: .amaranthApprox,
            imageName: "trash",
            imageColor: .amaranthApprox,
            accessoryImageName: ""
        )
    }

    private func participantsHeader() -> some View {
        HStack {
            Text("Участники")
                .font(.system(size: 17, weight: .semibold))
                .foregroundColor(.black)
            Spacer()
            Text("Добавить")
                .font(.system(size: 17))
                .foregroundColor(.azureRadianceApprox)
                .onTapGesture {
                    showAddUser = true
                }
        }
    }

    @ViewBuilder
    private func channelParticipantsView() -> some View {
        ForEach(viewModel.getChannelUsers(), id: \.self) { item in
            if viewModel.getChannelUsers().index(of: item) ?? 2 < 2 {
                ChannelParticipantView(
                    title: item.name,
                    subtitle: item.role.rawValue
                )
                .background(.white())
            }
        }
    }

    private func participantsFooter() -> some View {
        Text("Посмотреть все ( \(viewModel.getChannelUsers().count) участник )")
            .font(.system(size: 17, weight: .semibold))
            .foregroundColor(.azureRadianceApprox)
            .onTapGesture {
                showParticipantsView = true
            }
    }

    @ToolbarContentBuilder
    private func createToolBar() -> some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
            Button(action: {
                changeScreen()
            }, label: {
                R.image.navigation.backButton.image
            })
        }
        ToolbarItem(placement: .navigationBarTrailing) {
            Button(action: {
                changeScreen()
            }, label: {
                Text("Изменить")
                    .font(.system(size: 17))
                    .foregroundColor(.azureRadianceApprox)
            })
        }
    }

    @ToolbarContentBuilder
    private func createChangeToolBar() -> some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
            Button(action: {
                withAnimation(.linear(duration: 0.5)) {
                    changeScreen()
                }
            }, label: {
                Text(R.string.localizable.personalizationCancel())
                    .font(.system(size: 17))
                    .foregroundColor(.azureRadianceApprox)
            })
        }
        ToolbarItem(placement: .navigationBarTrailing) {
            Button(action: {
                changeScreen()
            }, label: {
                Text(R.string.localizable.profileDetailRightButton())
                    .font(.bold(17))
                    .foregroundColor(.azureRadianceApprox)
            })
        }
    }

    private func changeScreen() {
        withAnimation(.linear(duration: 0.35)) {
            changeState.toggle()
        }
    }
}

// MARK: - TextFieldChannelView

struct TextFieldChannelView: View {

    // MARK: - Internal Properties

    @Binding var text: String
    var placeholder: String

    // MARK: - Body

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            TextField("",
                      text: $text)
                .foreground(.black())
                .background(.white())
                .cornerRadius(radius: 8, corners: .allCorners)
                .frame(height: 46)
                .font(.regular(15))
                .padding([.leading, .trailing], 16)
        }
    }
}
