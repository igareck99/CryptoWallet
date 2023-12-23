import SwiftUI

// MARK: - MicrophoneMessageView

struct MicrophoneMessageView: View {

    // MARK: - Internal Properties

    @Binding var showAudioView: Bool
    @Binding var blockDragPadding: CGFloat
    @Binding var blockAudioRecord: Bool
    @Binding var textDragPadding: CGFloat
    @Binding var resetAudio: Bool
    @Binding var sendAudio: Bool

    // MARK: - Private Properties

    @State private var bottomPadding: CGFloat = 0
    @State private var microphonePadding: CGFloat = 0
    @State var isSwiped = false

    // MARK: - Body

    var body: some View {
        content
    }

    // MARK: - Private properties

    private var content: some View {
        VStack {
            microphoneStartView
                .gesture(drag)
                .onChange(of: showAudioView) { _ in
                    blockAudioRecord = false
                }
        }
    }

    private var microphoneStartView: some View {
        ZStack {
            if showAudioView {
                VStack(alignment: .center, spacing: 16) {
                    recordView
                    Button(action: {
                        if showAudioView {
                            showAudioView = false
                        }
                    }, label: {
                        blockAudioRecord ? R.image.chat.audio.approveVoiceMessage.image :
                        R.image.chat.audio.buttonVoice.image
                    })
                }
                .padding(.leading, textDragPadding)
                .padding(.bottom, 80)
                .onDisappear {
                    withAnimation(.easeIn(duration: 0.25)) {
                        blockAudioRecord = false
                        blockDragPadding = 0
                        textDragPadding = 0
                    }
                }
                .padding(.top, blockDragPadding)
            } else {
                R.image.chat.audio.microfone.image
                    .frame(width: 30, height: 30)
                    .padding(.trailing, 6)
            }
        }
        .padding(.trailing, showAudioView ? 52 : 8)
    }

    private var recordView: some View {
        VStack(alignment: .center, spacing: blockAudioRecord ? 20 : 40) {
            ZStack {
                RoundedRectangle(cornerRadius: 40)
                    .fill(Color.white)
                    .overlay(content: {
                        RoundedRectangle(cornerRadius: 40)
                            .stroke(Color.lightGray, lineWidth: 0.5)
                    })
                    .frame(width: blockAudioRecord ? 34 : 73 - blockDragPadding,
                           height: 34)
                    .rotationEffect(Angle(degrees: 90))
                if blockAudioRecord {
                    R.image.chat.audio.closedlockImage.image
                        .frame(width: 20, height: 20, alignment: .center)
                } else {
                    VStack(spacing: 25 - blockDragPadding) {
                        R.image.chat.audio.openedlockImage.image
                            .frame(width: 20, height: 20, alignment: .center)
                        R.image.chat.audio.upblueArrow.image
                            .frame(width: 20, height: 10, alignment: .center)
                    }
                }
            }
        }
    }

    // MARK: - Private Properties

    private var drag: some Gesture {
        DragGesture(minimumDistance: 0, coordinateSpace: .global)
            .onChanged { value in
                showAudioView = true
                if !blockAudioRecord {
                    if value.startLocation.x > value.location.x {
                        guard abs(value.translation.width) < 75 else {
                            finishRecord()
                            return
                        }
                        microphonePadding = value.translation.width
                        textDragPadding = value.translation.width
                    }
                    if value.startLocation.y > value.location.y {
                        blockDragPadding = abs(value.translation.height)
                        bottomPadding = blockDragPadding
                        if blockDragPadding >= 20 {
                            blockAudioRecord = true
                            blockDragPadding = 20
                            return
                        }
                    }
                }
            }
            .onEnded { value in
                textDragPadding = 0
                if !blockAudioRecord {
                    finishRecord()
                }
                guard abs(value.translation.width) < 75 else { return }
                sendAudio = true
            }
    }
    
    private func finishRecord() {
        withAnimation(.easeIn(duration: 0.25)) {
            textDragPadding = 0
            microphonePadding = 0
            resetAudio = true
            showAudioView = false
        }
    }
}
