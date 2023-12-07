import SwiftUI

struct AvatarLetterView: View {
    let model: AvatarLetter

    var body: some View {
        Circle()
            .fill(model.backColor)
            .overlay(
                Text(model.letter)
                    .font(.bodyRegular17)
                    .foregroundColor(.white)
            )
    }
}
