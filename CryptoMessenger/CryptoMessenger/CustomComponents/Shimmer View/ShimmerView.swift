import SwiftUI

// MARK: - ShimmerView

struct ShimmerView: View {

    // MARK: - Internal Properties

    let model: ShimmerModel
    private let duration = Double(1.1)
    private let minOpacity = Double(0.15)
    private let maxOpacity = Double(0.45)
    private let cornerRadius: CGFloat

    // MARK: - Private Properties

    @State private var opacity: Double = 0.15

    // MARK: - Lifecycle

    init(
        model: ShimmerModel = .dShimmer,
        cornerRadius: CGFloat = .zero
    ) {
        self.model = model
        self.cornerRadius = cornerRadius
    }

    // MARK: - Content

    var body: some View {
        RoundedRectangle(cornerRadius: cornerRadius)
            .fill(model.shimmColor)
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
