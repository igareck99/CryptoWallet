import SwiftUI

// MARK: - TextEditorWithPlaceholder

struct TextEditorWithPlaceholder: View {

    @Binding var text: String

    // MARK: - Body

    var body: some View {
        ZStack(alignment: .leading) {
            if text.isEmpty {
                VStack {
                    Text("Описание")
                        .padding(.top, 11)
                        .opacity(0.7)
                        .padding(.leading, 16)
                        .foreground(.slateGray)
                    Spacer()
                }
            }
            VStack {
                TextEditor(text: $text)
                    .scrollContentBackground(.hidden)
                    .background(Color.aliceBlue)
                    .font(.bodyRegular17)
                    .cornerRadius(8)
                    .opacity(text.isEmpty ? 0.85 : 1)
                Spacer()
            }
        }
        .onAppear {
            UITextView.appearance().textContainerInset = .init(top: 11, left: 16, bottom: 0, right: 0)
        }
    }
}
