import SwiftUI

// MARK: - ShimmerView

struct ShimmerView: View {

    // MARK: - Internal Properties

    private let duration = Double(1.1)
    private let minOpacity = Double(0.15)
    private let maxOpacity = Double(0.45)
    private let cornerRadius: CGFloat

    // MARK: - Private Properties

    @State private var opacity: Double

    // MARK: - Lifecycle

    init(cornerRadius: CGFloat = 0) {
        self.opacity = minOpacity
        self.cornerRadius = cornerRadius
    }

    // MARK: - Content

    var body: some View {
        RoundedRectangle(cornerRadius: cornerRadius)
            .fill(Color(.gray768286()))
            .opacity(opacity)
            .transition(.opacity)
            .onAppear {
                let baseAnimation = Animation.easeInOut(duration: duration)
                let repeated = baseAnimation.repeatCount(0)
                withAnimation(repeated) {
                    self.opacity = maxOpacity
                }
        }
    }
}

// MARK: - Shimmer

struct Shimmer: ViewModifier {

    // MARK: - Private Properties

    @State private var phase = CGFloat(0)

    // MARK: - Internal Properties

    var duration = 1.5
    var bounce = false

    // MARK: - Content

    func body(content: Content) -> some View {
        content
            .modifier(
                AnimatedMask(phase: phase).animation(
                    .linear(duration: duration)
                    .repeatForever()
                )
            )
            .onAppear { phase = 0.8 }
    }

    // MARK: - AnimatedMask

    struct AnimatedMask: AnimatableModifier {

        // MARK: - Internal Properties

        var phase: CGFloat = 0
        var animatableData: CGFloat {
            get { phase }
            set { phase = newValue }
        }

        // MARK: - Internal Methods

        func body(content: Content) -> some View {
            content
                .mask(GradientMask(phase: phase).scaleEffect(3))
        }
    }

    // MARK: - GradientMask

    struct GradientMask: View {

        // MARK: - Internal Properties

        let phase: CGFloat
        let centerColor: Palette = .blue()
        let edgeColor: Palette = .blue(0.3)

        // MARK: - Lifecycle

        var body: some View {
            LinearGradient(
                gradient:
                    Gradient(stops: [
                        .init(color: edgeColor.suColor, location: phase),
                        .init(color: centerColor.suColor, location: phase + 0.1),
                        .init(color: edgeColor.suColor, location: phase + 0.2)
                    ]),
                startPoint: .leading,
                endPoint: .trailing
            )
        }
    }
}

// MARK: - View (Shimmer)

extension View {
    @ViewBuilder func shimmering(
        active: Bool = true,
        duration: Double = 1.5,
        bounce: Bool = false
    ) -> some View {
        if active {
            modifier(Shimmer(duration: duration, bounce: bounce))
        } else {
            self
        }
    }
}
