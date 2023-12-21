import SwiftUI

// MARK: - ChatInputView

struct ChatInputView: View {

    var data: ChatInputViewModel
    @State var textViewHeight: CGFloat = 34
    @State private var showAudioView = false
    @State var blockDragPadding: CGFloat = 0
    @State private var textDragPadding: CGFloat = 0
    @State private var blockAudioRecord = false
    @State private var resetAudio = false
    @State private var sendAudio = false
    @State var isPlusShown = true
    @State var recordingDataModel: RecordingDataModel?
    var sources: ChatRoomSourcesable.Type = ChatRoomResources.self
    
    // MARK: - Body
    
    var body: some View {
        switch data.isWriteEnable {
        case true:
            VStack(spacing: 0) {
                if data.quickAction == .reply {
                    ReplyView(text: data.replyDescriptionText,
                              viewType: .reply) {
                        data.activeEditMessage = nil
                        data.quickAction = nil
                    }.transition(.opacity)
                }
                if data.quickAction == .edit {
                    ReplyView(text: data.replyDescriptionText,
                              viewType: .edit) {
                        data.activeEditMessage = nil
                        data.quickAction = nil
                    }.transition(.opacity)
                }
                inputView
            }
            .onChange(of: data.inputText) { value in
                withAnimation(.linear(duration: 0.05)) {
                    isPlusShown = value.isEmpty &&
                    !(data.$quickAction.wrappedValue == .reply || data.$quickAction.wrappedValue == .edit)
                }
            }
            .onChange(of: data.quickAction) { value in
                withAnimation(.linear(duration: 0.05)) {
                    isPlusShown = data.$inputText.wrappedValue.isEmpty &&
                    !(value == .reply || value == .edit)
                }
            }
        case false:
            accessDeniedView
        }
    }
    
    // MARK: - Private Properties
    
    private var accessDeniedView: some View {
        HStack(alignment: .center, spacing: 0) {
            Text("У вас нет разрешения на публикацию в этом канале")
                .font(.subheadlineRegular15)
                .foregroundColor(.romanSilver)
                .padding(.horizontal, 8)
                .padding(.vertical, 16)
        }
        .padding(.bottom, 16)
        .frame(maxWidth: .infinity)
        .background(Color.white)
    }
    
    var inputView: some View {
        VStack(spacing: 0) {
            HStack(alignment: .center) {
                if showAudioView {
                    HStack(alignment: .center) {
                        AudioInputMessageView(audioUrl: $recordingDataModel,
                                              showAudioView: $showAudioView,
                                              blockAudioRecord: $blockAudioRecord,
                                              textDragPadding: $textDragPadding,
                                              blockDragPadding: $blockDragPadding,
                                              resetAudio: $resetAudio,
                                              sendAudio: $sendAudio, recordOnSend: { value in
                            data.sendAudio(value)
                        })
                        .padding(.leading, 12)
                        .padding(.trailing, 8)
                        Spacer()
                    }
                } else {
                    if isPlusShown {
                        Button(action: {
                        }, label: {
                            sources.plus
                                .resizable()
                                .foreground(.romanSilver)
                                .frame(width: 20, height: 20)
                                .onTapGesture {
                                    data.onChatRoomMenu()
                                }
                        })
                        .padding(.leading, 11)
                    }
                    ResizeableTextView(
                        text: data.$inputText,
                        height: $textViewHeight,
                        placeholderText: sources.inputViewPlaceholder
                    )
                    .cornerRadius(radius: 60, corners: .allCorners)
                    .addBorder(Color.gainsboro, width: 0.5, cornerRadius: 60)
                    .padding(.leading, isPlusShown ? 11 : 16)
                    .padding(.trailing, isPlusShown ? 6 : 10)
                    .frame(height: min(textViewHeight, 160))
                    .keyboardType(.default)
                }
                if !data.inputText.isEmpty {
                    Button(action: {
                        data.sendText()
                        withAnimation {
                            textViewHeight = 34
                        }
                    }, label: {
                        sources.paperPlane
                            .foregroundColor(.dodgerBlue)
                            .frame(width: 24, height: 24)
                            .clipShape(Circle())
                            .padding(.trailing, 10)
                    })
                } else {
                    MicrophoneMessageView(showAudioView: $showAudioView,
                                          blockDragPadding: $blockDragPadding,
                                          blockAudioRecord: $blockAudioRecord,
                                          textDragPadding: $textDragPadding,
                                          resetAudio: $resetAudio,
                                          sendAudio: $sendAudio)
                    .frame(width: 24,
                           height: 24)
                }
            }
        }
        .frame(height: min(textViewHeight + 11, 160))
        .background(Color.white)
    }
}
