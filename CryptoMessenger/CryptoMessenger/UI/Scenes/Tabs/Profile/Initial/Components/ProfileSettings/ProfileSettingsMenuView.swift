import SwiftUI
// swiftlint: disable: all
// MARK: - ProfileSettingsMenuView

struct ProfileSettingsMenuView: View {
    // MARK: - Internal Properties
    @AppStorage("selectedAppearance") var selectedAppearance = 0
    @StateObject var viewModel = ProfileSettingsMenuViewModel()
    let balance: String
    let onSelect: GenericBlock<ProfileSettingsMenu>
    var appearanceService = AppearanceService()
    // MARK: - Body
    
    var body: some View {
        VStack(spacing: 0) {
            RoundedRectangle(cornerRadius: 2)
                .frame(width: 31, height: 4)
                .foreground(.darkGray(0.4))
                .padding(.top, 6)
            HStack(spacing: 8) {
                R.image.buyCellsMenu.aura.image
                    .resizable()
                    .frame(width: 24, height: 24)
                Text(balance, [
                    .paragraph(.init(lineHeightMultiple: 1.17, alignment: .left)),
                    .font(.regular(16)),
                    .color(.black())
                ])
                Spacer()
            }
            .padding(.top, 8)
            .padding([.leading, .trailing], 16)
            
            Divider()
                .foreground(.grayE6EAED())
                .padding(.top, 16)
            
            List {
                ForEach(viewModel.settingsTypes(), id: \.self) { type in
                    if type == .questions {
                        Divider()
                            .listRowInsets(.init())
                            .foreground(.grayE6EAED())
                            .padding([.top, .bottom], 16)
                    }
                    if type == .wallet && !viewModel.isPhraseAvailable {
                        EmptyView()
                    } else {
                        ProfileSettingsMenuRow(title: type.result.title, image: type.result.image, notifications: 0)
                            .background(Color.primaryColor)
                            .frame(height: 64)
                            .listRowInsets(.init())
                            .listRowSeparator(.hidden)
                            .onTapGesture { onSelect(type) }
                    }
                }
            }
            .listStyle(.plain)
            HStack {
                Spacer()

                Button {
                    selectedAppearance = 1
                }  label: {
                    Text("Light")
                }
                Spacer()
                Button {
                    selectedAppearance = 2
                } label: {
                    Text("Dark")
                }
                Spacer()
                Button {
                    selectedAppearance = 0
                } label: {
                    Text("System")
                }
                Spacer()
                Button {
                    selectedAppearance = 3
                } label: {
                    Text("Custom")
                }
                Spacer()
            }
            .padding(.bottom, 200)
            .onChange(of: selectedAppearance, perform: { _ in
                appearanceService.overrideDisplayMode()
            })
            Divider()
        }.background(Color.primaryColor)
    }
}
