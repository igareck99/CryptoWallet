import SwiftUI

// MARK: - ErrorView

struct ErrorView: View {

    // MARK: - Internal Properties

    @Environment(\.presentationMode) var presentationMode

    // MARK: - Body

    var body: some View {
        VStack {
            Text("What do you think could go wrong? 🤔")
                .font(.bold(15))
                .padding()
            Button {
                presentationMode.wrappedValue.dismiss()
            }
        label: {
            Text("Dismiss")
                .font(.bold(15))
        }
        }
    }
}
