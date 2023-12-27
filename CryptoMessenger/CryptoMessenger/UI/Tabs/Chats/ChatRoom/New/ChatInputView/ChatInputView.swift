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
    @State private var cornerRadius: CGFloat = 60
    @State var isPlusShown = true
    @State var recordingDataModel: RecordingDataModel?
    var sources: ChatRoomSourcesable.Type = ChatRoomResources.self

    // MARK: - Body

    var body: some View {
            switch data.isWriteEnable {
            case true:
                VStack(spacing: .zero) {
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
                    isPlusShown = value.isEmpty &&
                    !(data.$quickAction.wrappedValue == .reply || data.$quickAction.wrappedValue == .edit)
                }
                .onChange(of: data.quickAction) { value in
                isPlusShown = data.$inputText.wrappedValue.isEmpty &&
                !(value == .reply || value == .edit)
                }
                .onChange(of: textViewHeight) { value in
                    if value <= 34 {
                        cornerRadius = 60
                    } else {
                        cornerRadius = 20
                    }
                }
            case false:
                accessDeniedView
            }
        }
    
    // MARK: - Private Properties
    
    private var accessDeniedView: some View {
        VStack(alignment: .center) {
            Text("У вас нет разрешения на публикацию в этом канале")
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .font(.subheadlineRegular15)
                .foregroundColor(.romanSilver)
                .padding(.horizontal, 71)
                .background(.white())
                .frame(minHeight: 40, idealHeight: 40, maxHeight: 40,
                       alignment: .center)
        }
        .frame(height: 45)
    }
    
    var inputView: some View {
        VStack(spacing: .zero) {
            HStack(alignment: .center, spacing: .zero) {
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
                                .frame(width: 30, height: 30)
                                .onTapGesture {
                                    data.onChatRoomMenu()
                                }
                        })
                        .padding(.leading, 6)
                    }
                    ResizeableTextView(
                        text: data.$inputText,
                        height: $textViewHeight,
                        cornerRadius: $cornerRadius,
                        placeholderText: sources.inputViewPlaceholder
                    )
                    .foreground(.aliceBlue)
                    .addBorder(Color.gainsboro, width: 0.5, cornerRadius: cornerRadius)
                    .padding(.leading, isPlusShown ? 11 : 16)
                    .padding(.trailing, isPlusShown ? 18 : 16)
                    .frame(height: min(textViewHeight, 148))
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
                            .frame(width: 28, height: 28)
                            .padding(.trailing, 10)
                    })
                } else {
                    MicrophoneMessageView(showAudioView: $showAudioView,
                                          blockDragPadding: $blockDragPadding,
                                          blockAudioRecord: $blockAudioRecord,
                                          textDragPadding: $textDragPadding,
                                          resetAudio: $resetAudio,
                                          sendAudio: $sendAudio)
                    .frame(width: 30,
                           height: 30)
                }
            }
        }
        .frame(height: min(textViewHeight + 11, 160))
        .background(Color.white)
    }
}
