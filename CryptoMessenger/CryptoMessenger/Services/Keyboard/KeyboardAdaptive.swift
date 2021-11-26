import Combine
import SwiftUI

// MARK: - KeyboardAdaptive

struct KeyboardAdaptive: ViewModifier {

    // MARK: - Private Properties

    @State private var bottomPadding = CGFloat(0)

    func body(content: Content) -> some View {
        GeometryReader { geometry in
            content
                .padding(.bottom, bottomPadding)
                .onReceive(Publishers.keyboardHeight) { keyboardHeight in
                    let keyboardTop = geometry.frame(in: .global).height - keyboardHeight
                    let focusedTextInputBottom = UIResponder.currentFirstResponder?.globalFrame?.maxY ?? 0
                    bottomPadding = max(0, focusedTextInputBottom - keyboardTop - geometry.safeAreaInsets.bottom)
            }
                .animation(.easeOut, value: 0.16)
        }
    }
}

// MARK: - View ()

extension View {

    // MARK: - Internal Methods

    func keyboardAdaptive() -> some View {
        ModifiedContent(content: self, modifier: KeyboardAdaptive())
    }
}
