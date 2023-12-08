import SwiftUI

// MARK: - AudioInputMessageView

struct AudioInputMessageView: View {

    // MARK: - Internal Properties

    @Binding var audioUrl: RecordingDataModel?
    @Binding var showAudioView: Bool
    @Binding var blockAudioRecord: Bool
    @Binding var textDragPadding: CGFloat
    @Binding var blockDragPadding: CGFloat
    @Binding var resetAudio: Bool
    @Binding var sendAudio: Bool
    let recordOnSend: (RecordingDataModel) -> Void

    // MARK: - Private Properties

    @StateObject var audioRecord = AudioRecorder()
    @State private var bottomPadding: CGFloat = 0
    @State private var leadingCancel: CGFloat = UIScreen.main.bounds.width - 342
    @State private var leadingLeftPadding: CGFloat = UIScreen.main.bounds.width - 305

    // MARK: - Body

    var body: some View {
        content
            .onAppear {
                textDragPadding = 0
                blockDragPadding = 0
                resetAudio = false
            }
            .onChange(of: showAudioView, perform: { flag in
                if !flag {
                    audioRecord.stopRecording()
                    audioRecord.fetchRecordings { record in
                        guard let record = record else {  return}
                        if sendAudio {
                            recordOnSend(record)
                            sendAudio = false
                        } else {
                            audioUrl = nil
                        }
                    }
                }
            })
            .onAppear {
                audioRecord.startRecording()
            }
    }

    // MARK: - Private Properties

    private var content: some View {
        HStack(alignment: .center) {
            timerView
            HStack {
                if blockAudioRecord {
                    canceText
                        .padding(.leading, leadingLeftPadding)
                } else {
                    textView
                        .padding(.leading, leadingCancel + textDragPadding)
                }
            }
        }
    }

    private var timerView: some View {
        HStack(spacing: 8) {
            Circle()
                .frame(width: 10,
                       height: 10)
                .foregroundColor(.spanishCrimson)
            TimerView(isTimerRunning: true)
                .frame(minWidth: 44,
                       maxWidth: 60)
        }
        .frame(width: 73, height: 21, alignment: .leading)
    }

    private var textView: some View {
        HStack(spacing: .zero) {
            R.image.chat.audio.leftGrayArrow.image
            Text(R.string.localizable.chatRoomViewAudioCancel())
                .lineLimit(1)
                .font(.regular(15))
                .foreground(Color(.init(r: 138, g: 145, b: 156)))
        }
    }

    private var canceText: some View {
        Button {
            resetRecordAudio()
        } label: {
            Text("Отмена")
                .font(.regular(15))
                .foregroundColor(.brilliantAzure)
        }
    }
    
    private func resetRecordAudio() {
        withAnimation(.easeIn(duration: 0.15)) {
            resetAudio = true
            sendAudio = false
            showAudioView = false
            blockDragPadding = 0
            textDragPadding = 0
        }
    }
}
