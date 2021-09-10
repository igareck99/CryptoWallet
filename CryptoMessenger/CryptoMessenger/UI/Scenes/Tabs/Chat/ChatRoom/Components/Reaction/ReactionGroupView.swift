import SwiftUI

// MARK: - ReactionGroupView

struct ReactionGroupView: View {

    // MARK: - Internal Properties

    private let text: String
    private let count: Int
    private let backgroundColor: Color

    // MARK: - Lifecycle

    init(text: String, count: Int, backgroundColor: Color) {
        self.text = text
        self.count = count
        self.backgroundColor = backgroundColor
    }

    // MARK: - Body

    var body: some View {
        HStack(spacing: 2) {
            Text(text)
                .font(.regular(15))

            Text(count.description)
                .font(.regular(12))
                .foreground(.custom(#colorLiteral(red: 0.1019607843, green: 0.1803921569, blue: 0.2078431373, alpha: 1)))
        }
        .padding(EdgeInsets(top: 4, leading: 8, bottom: 4, trailing: 8))
        .background(backgroundColor)
        .cornerRadius(8)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color(.custom(#colorLiteral(red: 0.7921568627, green: 0.8117647059, blue: 0.8235294118, alpha: 1))), lineWidth: 0.5)
        )
        .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
    }
}

// MARK: - ReactionGroupView_Previews

struct ReactionGroupView_Previews: PreviewProvider {
    static var reactionView: some View {
        ReactionGroupView(
            text: "💩",
            count: 42,
            backgroundColor: Color(.white())
        )
    }

    static var previews: some View {
        Group {
            reactionView
                .padding()
                .previewLayout(.sizeThatFits)
        }
    }
}
