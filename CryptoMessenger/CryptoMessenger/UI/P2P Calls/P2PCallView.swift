import SwiftUI

// swiftlint:disable all

struct P2PCallView<ViewModel: CallViewModelProtocol>: View {
    
    @StateObject var viewModel: ViewModel
    @Environment(\.presentationMode) private var presentationMode
    
    var body: some View {
        NavigationView {
            ZStack {

                Color.black
                
                Image(uiImage: viewModel.userAvatarImage)
                    .resizable()
                    .scaledToFill()
                    .opacity(viewModel.avatarOpacity)
                
                CallsVideoView(view: viewModel.interlocutorCallView)
                    .foregroundColor(.clear)
                HStack(alignment: .top) {
                    Spacer()
                    VStack(alignment: .trailing) {
                        CallsVideoView(view: viewModel.selfyCallView)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .frame(width: 120, height: 180)
                            .foregroundColor(.clear)
                            .padding(.bottom, 32)
                            .padding(.trailing, 140)
                    }
                    .frame(maxHeight: .infinity)
                }
                .frame(maxWidth: .infinity)
            }
        }
        .safeAreaInset(edge: .bottom) {
            VStack(spacing: 36) {
                mediaButtons
                controlButtons
            }
            .padding(.bottom, 30)
        }
        .safeAreaInset(edge: .top) {
            callInformation
                .padding(.top, 24)
        }
        .onAppear {
            viewModel.controllerDidAppear()
        }
        .onDisappear {
            viewModel.controllerDidDisappear()
        }
        .toolbar {
            // TODO: После переделки навбара
//            createToolBar()
        }
    }
    
    @ViewBuilder
    var callInformation: some View {
        VStack(spacing: 8) {
            
            Text(viewModel.userName)
                .font(.system(size: 21))
                .foregroundColor(.white)
                .padding(.horizontal, 8)
            
            
            Text(viewModel.callStateText)
                .font(.system(size: 15))
                .foregroundColor(.white)
                .padding(.horizontal, 8)
            
            Text(viewModel.callDuration)
                .font(.system(size: 15))
                .foregroundColor(.white)
                .padding(.horizontal, 8)
            
            Spacer()
        }
    }
    
    var mediaButtons: some View {
        HStack(spacing: 0) {
            
            Spacer()
            
            ForEach(viewModel.mediaButtons, id: \.id) { model in
                Button(action: {
                    model.action()
                }) {
                    VStack {
                        Image(systemName: model.imageName)
                            .resizable()
                            .scaledToFit()
                            .padding()
                            .foregroundColor(model.imageColor)
                            .background(
                                Circle()
                                    .foregroundColor(model.backColor)
                                    .frame(width: 68, height: 68)
                            )
                            .frame(width: 68, height: 68)
                        
                        Text(model.text)
                            .font(.system(size: 11))
                            .foregroundColor(.white)
                    }
                }
                Spacer()
            }
        }
    }
    
    var controlButtons: some View {
        HStack(spacing: 0) {
            
            Spacer()
            
            ForEach(viewModel.actionButtons, id: \.id) { model in
                
                Button(action: {
                    model.action()
                }) {
                    Image(systemName: model.imageName)
                        .resizable()
                        .scaledToFit()
                        .padding()
                        .foregroundColor(model.imageColor)
                        .background(
                            Circle()
                                .foregroundColor(model.backColor)
                                .frame(width: 68, height: 68)
                        ).frame(width: 68, height: 68)
                }
                Spacer()
            }
        }
    }
    
    // Пока не используется, нужно переделать навбар
    @ToolbarContentBuilder
    private func createToolBar() -> some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
            Button(action: {
                presentationMode.wrappedValue.dismiss()
            }, label: {
                Image(systemName: viewModel.sources.backButtonImgName)
                    .foregroundColor(.white)
            })
        }
        ToolbarItem(placement: .principal) {
            Text(viewModel.sources.endToEndEncrypted)
                .font(.system(size: 15))
                .foregroundColor(.white)
        }
    }
}