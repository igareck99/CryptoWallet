import SwiftUI

// MARK: - ErrorView

struct ErrorView: View {

    // MARK: - Internal Properties

    @Environment(\.presentationMode) var presentationMode

    // MARK: - Body

    var body: some View {
        VStack {
            Text("What do you think could go wrong? 🤔")
                .font(.headlineBold17)
                .padding()
            Button {
                presentationMode.wrappedValue.dismiss()
            }
        label: {
            Text("Dismiss")
                .font(.headlineBold17)
        }
        }
    }
}
