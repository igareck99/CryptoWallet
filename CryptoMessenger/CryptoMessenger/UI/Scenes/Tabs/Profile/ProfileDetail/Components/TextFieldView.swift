import SwiftUI

// MARK: - TextFieldView

struct TextFieldView: View {

    // MARK: - Internal Properties

    var title = ""
    @Binding var text: String
    var placeholder: String

    // MARK: - Body

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title, [
                .font(.semibold(12)),
                .paragraph(.init(lineHeightMultiple: 1.54, alignment: .left)),
                .color(.gray768286())

            ]).frame(height: 22)
            HStack {
                TextField(placeholder, text: $text)
                    .foreground(.black())
                    .frame(height: 44)
                    .font(.regular(15))
                    .padding([.leading, .trailing], 16)
            }
            .background(.paleBlue())
            .cornerRadius(8)
        }
    }
}
