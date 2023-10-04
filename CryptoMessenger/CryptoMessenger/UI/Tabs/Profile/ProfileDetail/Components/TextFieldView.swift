import SwiftUI

// MARK: - TextFieldView

struct TextFieldView: View {

    // MARK: - Internal Properties

    var title = ""
    @Binding var text: String
    var placeholder: String
    var color: Color = .aliceBlue

    // MARK: - Body

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            if !title.isEmpty {
                Text(title, [
                    .paragraph(.init(lineHeightMultiple: 1.54, alignment: .left))
                ])
                .font(.caption1Medium12)
                .foregroundColor(.romanSilver)
                .frame(height: 22)
            }
            HStack {
                TextField(placeholder, text: $text)
                    .padding(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 0))
                    .foregroundColor(.chineseBlack)
                    .frame(height: 44)
                    .font(.subheadlineRegular15)
                    .background(Color.white
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                    )
            }
        }
    }
}
