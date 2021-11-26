import Combine
import SwiftUI

struct KeyboardAvoiderModifier: ViewModifier {

    @ObservedObject var keyboardHandler = KeyboardHandler()

    func body(content: Content) -> some View {
        content
            .padding(.bottom, keyboardHandler.keyboardHeight)
    }
}

extension View {
    func avoidKeyboard() -> some View {
        modifier(KeyboardAvoiderModifier())
    }
}
