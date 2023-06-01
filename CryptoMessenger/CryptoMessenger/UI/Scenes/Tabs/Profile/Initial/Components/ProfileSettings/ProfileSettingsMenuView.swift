import SwiftUI

// MARK: - ProfileSettingsMenuView

struct ProfileSettingsMenuView: View {
    class Utilities {
        
        // MARK: - Internal Properties
        @AppStorage("selectedAppearance") var selectedAppearance = 0
        var userInterfaceStyle: ColorScheme? = .dark
        
        func overrideDisplayMode() {
            var userInterfaceStyle: UIUserInterfaceStyle
            
            if selectedAppearance == 2 {
                userInterfaceStyle = .dark
            } else if selectedAppearance == 1 {
                userInterfaceStyle = .light
            } else {
                userInterfaceStyle = .unspecified
            }
            UIApplication.shared.windows.first?.overrideUserInterfaceStyle = userInterfaceStyle
        }
    }
    // MARK: - Internal Properties
    @AppStorage("selectedAppearance") var selectedAppearance = 0
    @StateObject var viewModel = ProfileSettingsMenuViewModel()
    let balance: String
    let onSelect: GenericBlock<ProfileSettingsMenu>
    var utilities = Utilities()
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
                            .background(.white())
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
                Button(action: {selectedAppearance = 1}){
                    Text("Light")}
                Spacer()
                Button(action: {selectedAppearance = 2}){
                    Text("Dark")}
                Spacer()
                Button(action: {selectedAppearance = 0}){
                    Text("System")}
                Spacer()
            }
            .padding(.bottom, 200)
            .onChange(of: selectedAppearance, perform: { value in
                utilities.overrideDisplayMode()
            })
            Divider()
        }.background(selectedAppearance == 1 ? Color.white : selectedAppearance == 2 ? Color.black : Color(UIColor.systemBackground))
    }
}
