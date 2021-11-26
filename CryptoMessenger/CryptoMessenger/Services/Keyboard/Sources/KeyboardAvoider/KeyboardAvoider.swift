import SwiftUI

struct KeyboardAvoider<Content:View>: View {
    
    private(set) var content: Content
    
    init(@ViewBuilder _ content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        ScrollView { content }.avoidKeyboard()
    }
}
