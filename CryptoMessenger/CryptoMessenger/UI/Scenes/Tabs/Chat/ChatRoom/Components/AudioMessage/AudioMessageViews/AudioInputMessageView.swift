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

    // MARK: - Private Properties

    private let audioRecord = AudioRecorder()
    @State private var bottomPadding: CGFloat = 0

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
                        if !resetAudio {
                            audioUrl = record
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
                Spacer()
                textView
                    .padding(.leading, textDragPadding)
                Spacer()
            }
            .gesture(cancelDrag)
        }
    }

    private var timerView: some View {
        HStack(spacing: 8) {
            Circle()
                .frame(width: 10,
                       height: 10)
                .foreground(.red())
            TimerView(isTimerRunning: true,
                      startTime: Date(),
                      timerString: "")
            .frame(width: 44)
        }
    }

    private var textView: some View {
        HStack(spacing: 8) {
            Text(R.string.localizable.chatRoomViewAudioCancel())
            R.image.chat.audio.leftblueArrow.image
        }
    }

    private var lockDrag: some Gesture {
        DragGesture()
            .onChanged { value in
                if !blockAudioRecord {
                    if value.startLocation.y > value.location.y {
                        blockDragPadding = abs(value.translation.height)
                        bottomPadding = blockDragPadding
                        if blockDragPadding >= 20 {
                            blockAudioRecord = true
                            blockDragPadding = 20
                        }
                    }
                    if value.startLocation.x > value.location.x {
                        textDragPadding = value.translation.width
                        if abs(value.translation.width) > 75 {
                            resetAudio = true
                            showAudioView = false
                        }
                    }
                }
            }
            .onEnded { _ in
                textDragPadding = 0
                bottomPadding = 0
            }
    }

    private var cancelDrag: some Gesture {
        DragGesture()
            .onChanged { value in
                if value.startLocation.x > value.location.x {
                    textDragPadding = value.translation.width
                    if abs(value.translation.width) > 75 {
                        resetAudio = true
                        showAudioView = false
                    }
                }
            }
            .onEnded { _ in
                textDragPadding = 0
            }
    }
}
