import SwiftUI

// MARK: - SliderAudioView

struct SliderAudioView: UIViewRepresentable {

    // MARK: - Internal Properties

    @Binding var value: Double
    @Binding var activateShowCard: Bool
    var thumbColor: UIColor = .white
    var minTrackColor: UIColor = #colorLiteral(red: 0.05490196078, green: 0.5568627451, blue: 0.9529411765, alpha: 1)
    var maxTrackColor: UIColor = #colorLiteral(red: 0.6235294118, green: 0.8352941176, blue: 0.9843137255, alpha: 1)
    var thumbSize: Double = 8

    // MARK: - Coordinator

    class Coordinator: NSObject {

        // MARK: - Internal Properties

        var value: Binding<Double>
        var activateShowCard: Binding<Bool>

        // MARK: - Lifecycle

        init(value: Binding<Double>,
             activateShowCard: Binding<Bool>) {
            self.value = value
            self.activateShowCard = activateShowCard
        }

        // MARK: - Actions

		@MainActor
        @objc func onSliderValChanged(_ sender: UISlider,
                                      _ event: UIEvent) {
            if let touchEvent = event.allTouches?.first {
                switch touchEvent.phase {
                case .began:
                    self.activateShowCard.wrappedValue = false
                case .moved:
                    self.value.wrappedValue = Double(sender.value)
                case .ended:
                    delay(0.2) {
                        self.activateShowCard.wrappedValue = true
                    }
                default:
                    break
                }
            }
        }
    }

    // MARK: - Internal Methods

    func makeCoordinator() -> SliderAudioView.Coordinator {
        Coordinator(value: $value, activateShowCard: $activateShowCard)
    }

    func makeUIView(context: Context) -> UISlider {
        let slider = UISlider(frame: .zero)
        slider.thumbTintColor = thumbColor
        slider.minimumTrackTintColor = minTrackColor
        slider.maximumTrackTintColor = maxTrackColor
        let image = UIImage(resource: R.image.chat.audio.voicemessageImage)?
            .resized(to: CGSize(width: thumbSize, height: thumbSize))
        slider.setThumbImage(image, for: .normal)
        slider.value = Float(value)
        slider.addTarget(
            context.coordinator,
            action: #selector(Coordinator.onSliderValChanged(_:_:)),
            for: .valueChanged
        )
        return slider
    }

	@MainActor
    func updateUIView(_ uiView: UISlider, context: Context) {
        uiView.value = Float(value)
    }
}
