import SwiftUI

// MARK: - ChatInputView

struct ChatInputView: View {

    var data: ChatInputViewModel
    @State var textViewHeight: CGFloat = 36
    @State private var showAudioView = false
    @State var blockDragPadding: CGFloat = 0
    @State private var textDragPadding: CGFloat = 0
    @State private var blockAudioRecord = false
    @State private var resetAudio = false
    @State private var sendAudio = false
    @State var recordingDataModel: RecordingDataModel?
    var sources: ChatRoomSourcesable.Type = ChatRoomResources.self

    var body: some View {
        switch data.isWriteEnable {
        case true:
            VStack(spacing: 0) {
                if data.quickAction == .reply {
                    ReplyView(
                        text: data.replyDescriptionText ?? "",
                        onReset: {
                            data.activeEditMessage = nil
                            data.quickAction = nil
                        }
                    ).transition(.opacity)
                }
                if data.quickAction == .edit {
                    EditView(
                        text: data.replyDescriptionText ?? "",
                        onReset: {
                            data.activeEditMessage = nil
                            data.quickAction = nil
                        }
                    ).transition(.opacity)
                }
                inputView
            }
        case false:
            accessDeniedView
        }
    }
    
    // MARK: - Private Properties
    
    private var accessDeniedView: some View {
        HStack(alignment: .center, spacing: 0) {
            Text("У вас нет разрешения на публикацию в этом канале")
                .font(.system(size: 15))
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
            HStack(spacing: 8) {
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
                        .ignoresSafeArea()
                        .padding(.leading, 12)
                        .padding(.trailing, 8)
                    }
                } else {
                    Button(action: {
                    }, label: {
                        sources.plus
                            .resizable()
                            .frame(width: 24, height: 24)
                            .onTapGesture {
                                data.onChatRoomMenu()
                            }
                    })
                    .padding(.leading, 8)
                    HStack {
                        ResizeableTextView(
                            text: data.$inputText,
                            height: $textViewHeight,
                            placeholderText: sources.inputViewPlaceholder
                        )
                        .keyboardType(.default)
                        .clipShape(RoundedRectangle(cornerRadius: 16,
                                                    style: .continuous))
                        .padding(.horizontal, 16)
                    }
                    .padding(.trailing, data.inputText.isEmpty ? 0 : 8)
                }
                if !data.inputText.isEmpty {
                    Button(action: {
                        data.sendText()
                        withAnimation {
                            textViewHeight = 36
                        }
                    }, label: {
                        sources.paperPlane
                            .foregroundColor(.dodgerBlue)
                            .frame(width: 24, height: 24)
                            .clipShape(Circle())
                    })
                    .padding(.trailing, 16)
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
            .padding(.top, 8)
            Spacer()
        }
        .frame(height: min(18 + textViewHeight, 160))
        .background(Color.white)
        .ignoresSafeArea()
    }
}
