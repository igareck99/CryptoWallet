import SwiftUI

struct ChannelInfoView<ViewModel: ChannelInfoViewModelProtocol>: View {
    
    @StateObject var viewModel: ViewModel
    @Environment(\.presentationMode) private var presentationMode
    
    var body: some View {
        
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
            
            Section {
                changeChannelTypeView()
                deleteChannelView()
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarTitleDisplayMode(.inline)
        .navigationViewStyle(.stack)
        .listStyle(.insetGrouped)
        .toolbar {
            createToolBar()
        }
        .popup(
            isPresented: viewModel.isSnackbarPresented,
            alignment: .bottom
        ) {
            Snackbar(
                text: "Ссылка скопирована",
                color: .green
            )
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
            accessoryImageName: ""
        )
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
                    debugPrint("add participants")
                }
        }
    }
    
    @ViewBuilder
    private func channelParticipantsView() -> some View {
        ChannelParticipantView(
            title: "Марина Антоненко",
            subtitle: "@mn50hdbcj9tegd"
        )
        
        ChannelParticipantView(
            title: "Данил Даньшин",
            subtitle: "@mvjbjs9572jcjeotr972cj9tegd"
        )
    }
    
    private func participantsFooter() -> some View {
        Text("Посмотреть все ( 41 участник )")
            .font(.system(size: 17, weight: .semibold))
            .foregroundColor(.azureRadianceApprox)
            .onTapGesture {
                debugPrint("participantsFooter")
            }
    }
    
    @ToolbarContentBuilder
    private func createToolBar() -> some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
            Button(action: {
                presentationMode.wrappedValue.dismiss()
            }, label: {
                R.image.navigation.backButton.image
            })
        }
        
        ToolbarItem(placement: .navigationBarTrailing) {
            Button(action: {
                presentationMode.wrappedValue.dismiss()
            }, label: {
                Text("Изменить")
                    .font(.system(size: 17))
                    .foregroundColor(.azureRadianceApprox)
            })
        }
    }
}
