import SwiftUI

// MARK: - KeyboardDismissModifier

struct KeyboardDismissModifier: ViewModifier {

    // MARK: - Body

    func body(content: Content) -> some View {
        content.onTapGesture {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
    }
}

// MARK: - View ()

extension View {

    // MARK: - Internal Methods

    func hideKeyboardOnTap() -> ModifiedContent<Self, KeyboardDismissModifier> {
        modifier(KeyboardDismissModifier())
    }

    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
