import SwiftUI
import Combine

// MARK: - PinCodeDotes

struct PinCodeDotes: View {

    // MARK: - Internal Properties

    @Binding var colors: [Color]
    @Binding var dotesAnimation: CGFloat
    @State private var animOffset = 0
    var spacing: CGFloat = 16

    // MARK: - Body

    var body: some View {
        HStack(spacing: spacing) {
            ForEach(colors, id: \.self) { value in
                Circle()
                    .fill(value)
                    .frame(width: 14, height: 14)
            }
            .modifier(ShakeAnimation(animatableData: CGFloat(animOffset)))
        }
        .onChange(of: $dotesAnimation.wrappedValue, perform: { _ in
            withAnimation(.default) {
                animOffset = 5
            }
        })
    }
}
