import SwiftUI

// MARK: KeyboardDismissModifier

struct KeyboardDismissModifier: ViewModifier {
    func body(content: Content) -> some View {
        content.onTapGesture {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
    }
}

extension View {
    func hideKeyboardOnTap() -> ModifiedContent<Self, KeyboardDismissModifier> {
        return modifier(KeyboardDismissModifier())
    }

    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
