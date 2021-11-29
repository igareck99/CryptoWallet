import SwiftUI

// MARK: - KeyboardAvoider

struct KeyboardAvoider<Content:View>: View {

    // MARK: - Internal Properties

    private(set) var content: Content

    // MARK: - Lifecycle

    init(@ViewBuilder _ content: () -> Content) {
        self.content = content()
    }

    // MARK: - Body

    var body: some View {
        ScrollView { content }.avoidKeyboard()
    }
}
