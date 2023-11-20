import SwiftUI

// swiftlint:disable all

struct P2PCallView<ViewModel: CallViewModelProtocol>: View {
    
    @StateObject var viewModel: ViewModel
    @Environment(\.presentationMode) private var presentationMode
    
    var body: some View {
        NavigationView {
            VStack(spacing: .zero) {
                if viewModel.isVideoCall {
                    CallsVideoView(view: viewModel.interlocutorCallView)
                        .foregroundColor(.clear)
                } else {
                    GeometryReader { proxy in
                        Image(uiImage: viewModel.userAvatarImage)
                            .resizable()
                            .scaledToFill()
                            .opacity(viewModel.avatarOpacity)
                            .frame(width: proxy.size.width, height: proxy.size.height)
                    }
                }
            }.background(Color.black)
            
                .overlay(alignment: .bottom) {
                    VStack(spacing: 36) {
                        HStack {
                            Spacer()
                            selfyView.padding(.trailing, 16)
                        }
                        mediaButtons
                        controlButtons
                    }
                    .padding(.bottom, 30)
                }.overlay(alignment: .top) {
                    callInformation.padding(.top, 24)
                }
        }
        .onAppear {
            viewModel.controllerDidAppear()
        }
        .onDisappear {
            viewModel.controllerDidDisappear()
        }
    }
    
    @ViewBuilder
    var callInformation: some View {
        VStack(spacing: 8) {
            HStack(spacing: 0) {
                Button {
                    viewModel.didTapBackButton()
                } label: {
                    Text(Image(systemName: "chevron.left"))
                        .font(.bodySemibold17)
                        .foregroundColor(.white)
                        .frame(width: 44, height: 44)
                }
                .padding(.leading, 8)
                .frame(width: 44, height: 44)
                Spacer()
                Text(viewModel.sources.endToEndEncrypted)
                    .foregroundColor(.white)
                    .font(.subheadlineRegular15)
                Spacer()
            }
            Text(viewModel.userName)
                .font(.title2Bold22)
                .foregroundColor(viewModel.sources.background)
                .padding(.horizontal, 8)
            
            
            Text(viewModel.callStateText)
                .font(.subheadlineRegular15)
                .foregroundColor(viewModel.sources.background)
                .padding(.horizontal, 8)
            
            Text(viewModel.callDuration)
                .font(.subheadlineRegular15)
                .foregroundColor(viewModel.sources.background)
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
                            .font(.caption2Regular11)
                            .foregroundColor(viewModel.sources.background)
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
    
    var selfyView: some View {
        CallsVideoView(view: viewModel.selfyCallView)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .frame(width: 120, height: 180)
            .foregroundColor(.clear)
    }
    
    // Пока не используется, нужно переделать навбар
    @ToolbarContentBuilder
    private func createToolBar() -> some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
            Button(action: {
                presentationMode.wrappedValue.dismiss()
            }, label: {
                Image(systemName: viewModel.sources.backButtonImgName)
                    .foregroundColor(viewModel.sources.background)
            })
        }
        ToolbarItem(placement: .principal) {
            Text(viewModel.sources.endToEndEncrypted)
                .font(.subheadlineRegular15)
                .foregroundColor(viewModel.sources.background)
        }
    }
}
