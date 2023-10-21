import SwiftUI

// MARK: - TextEditorWithPlaceholder

struct TextEditorWithPlaceholder: View {

    @Binding var text: String

    // MARK: - Body

    var body: some View {
        ZStack(alignment: .leading) {
            VStack {
                TextEditor(text: $text)
                    .scrollContentBackground(.hidden)
                    .background(Color.aliceBlue)
                    .font(.bodyRegular17)
                    .cornerRadius(8)
                Spacer()
            }
            if text.isEmpty {
                VStack {
                    Text("Описание")
                        .padding(.top, 11)
                        .padding(.leading, 16)
                        .foregroundColor(.manatee)
                        .opacity(0.5)
                    Spacer()
                }
            }
        }
        .onAppear {
            UITextView.appearance().textContainerInset = .init(top: 11, left: 16, bottom: 0, right: 0)
        }
    }
}
