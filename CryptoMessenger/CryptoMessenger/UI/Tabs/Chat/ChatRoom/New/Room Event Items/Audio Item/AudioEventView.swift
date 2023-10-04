import SwiftUI
import AVKit

// MARK: - AudioEventView

struct AudioEventView<EventData: View,
                      Reactions: View
>: View {

    // MARK: - Internal Properties

    @StateObject var viewModel: AudioMessageViewModel
    let eventData: EventData
    let reactions: Reactions
    @State private var activateShowCard = false

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(alignment: .center, spacing: 12) {
                AudioEventStateView(state: $viewModel.state)
                    .onTapGesture {
                        switch viewModel.state {
                        case .download:
                            viewModel.start()
                        case .play:
                            viewModel.play()
                        case .stop:
                            viewModel.stop()
                        default: 
                            break
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
                    Text(viewModel.data.audioDuration)
                        .font(.caption1Regular12)
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
        .onReceive(viewModel.timer, perform: { _ in
            viewModel.onTimerChange()
        })
        .frame(width: 230)
    }
}
