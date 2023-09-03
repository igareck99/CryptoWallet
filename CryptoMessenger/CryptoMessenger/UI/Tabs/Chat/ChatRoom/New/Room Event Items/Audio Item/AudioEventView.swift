import SwiftUI
import AVKit

// MARK: - AudioEventView

struct AudioEventView<EventData: View,
                      Reactions: View
>: View {

    // MARK: - Internal Properties

    @StateObject var viewModel: AudioMessageViewModel
    let data: AudioEventItem
    let eventData: EventData
    let reactions: Reactions
    @State private var activateShowCard = false

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(alignment: .center, spacing: 12) {
                Button(action: viewModel.play) {
                    ZStack {
                        Circle()
                            .foregroundColor(.accentColor)
                            .frame(width: 48, height: 48)
                            .cornerRadius(24)
                        !viewModel.isPlaying ?
                        R.image.chat.audio.audioPlay.image :
                        R.image.chat.audio.audioStop.image
                    }
                }
                VStack(alignment: .leading, spacing: 10) {
                    SliderAudioView(
                        value: Binding(get: { viewModel.time }, set: { newValue in
                            viewModel.onSlide(newValue)
                        }),
                        activateShowCard: $activateShowCard
                    )
                    .padding(.trailing, 8)
                    .frame(height: 1)
                    Text(data.audioDuration)
                        .font(.system(size: 12, weight: .regular))
                        .foregroundColor(.romanSilver)
                }
            }
            VStack(spacing: 2) {
                HStack {
                    reactions
                    Spacer()
                }
                eventData
            }
        }
        .onAppear {
            viewModel.start()
        }
        .onReceive(viewModel.timer, perform: { _ in
            viewModel.onTimerChange()
        })
        .frame(width: 230)
    }
}
