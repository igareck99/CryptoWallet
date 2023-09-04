import SwiftUI

// MARK: - MicrophoneMessageView

struct MicrophoneMessageView: View {

    // MARK: - Internal Properties

    @Binding var showAudioView: Bool
    @Binding var blockDragPadding: CGFloat
    @Binding var blockAudioRecord: Bool
    @Binding var textDragPadding: CGFloat
    @Binding var resetAudio: Bool
    @Binding var record: RecordingDataModel?

    // MARK: - Private Properties

    @State private var bottomPadding: CGFloat = 0
    @State private var microphonePadding: CGFloat = 0

    // MARK: - Body

    var body: some View {
        content
    }

    // MARK: - Private properties

    private var content: some View {
        VStack(spacing: blockDragPadding) {
            microphoneStartView
                .gesture(drag)
                .onChange(of: showAudioView) { _ in
                    blockAudioRecord = false
                }
        }
    }

    private var microphoneStartView: some View {
        ZStack {
            VStack {
                recordView
                Button(action: {
                    if showAudioView {
                        showAudioView = false
                    }
                }, label: {
                    ZStack {
                        Circle()
                            .frame(width: 48, height: 48)
                            .foreground(.dodgerBlue)
                        !blockAudioRecord ? R.image.chat.audio.whitemicrofoneImage.image :
                        R.image.chat.audio.approveWhite.image
                    }
                })
            }
            .padding(.leading, textDragPadding)
            .padding(.bottom, blockAudioRecord ? 55 : 70)
            .onDisappear {
                blockAudioRecord = false
                blockDragPadding = 0
                textDragPadding = 0
            }
            .opacity(showAudioView ? 1 : 0)
            .padding(.top, blockDragPadding)
            R.image.chat.audio.microfoneImage.image
                .foregroundColor(.dodgerBlue)
                .frame(width: 24, height: 24)
                .clipShape(Circle())
                .opacity(!showAudioView ? 1 : 0)
                .padding(.trailing, 16)
        }
        .padding(.trailing, 6)
    }

    private var recordView: some View {
        VStack(alignment: .center, spacing: blockAudioRecord ? 20 : 40) {
            ZStack {
                RoundedRectangle(cornerRadius: 45)
                    .fill(Color.white)
                    .frame(width: blockAudioRecord ? 34 : 73 - blockDragPadding,
                           height: 34)
                    .rotationEffect(Angle(degrees: 90))
                if blockAudioRecord {
                    R.image.chat.audio.closedlockImage.image
                } else {
                    VStack(spacing: 25 - blockDragPadding) {
                        R.image.chat.audio.openedlockImage.image
                        R.image.chat.audio.upblueArrow.image
                    }
                }
            }
        }
    }

    // MARK: - Private Properties

    private var drag: some Gesture {
        DragGesture(minimumDistance: 0)
            .onChanged { value in
                showAudioView = true
                if !blockAudioRecord {
                    if value.startLocation.x > value.location.x {
                        microphonePadding = value.translation.width
                        textDragPadding = value.translation.width
                        if microphonePadding > 75 {
                            resetAudio = true
                            showAudioView = false
                            microphonePadding = 0
                            textDragPadding = 0
                        }
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
                    if value.startLocation.x > value.location.x {
                        textDragPadding = value.translation.width
                        if abs(value.translation.width) > 75 {
                            resetAudio = true
                            showAudioView = false
                            return
                        }
                    }
                }
            }
            .onEnded { _ in
                textDragPadding = 0
                if !blockAudioRecord {
                    showAudioView = false
                }
            }
    }
}
