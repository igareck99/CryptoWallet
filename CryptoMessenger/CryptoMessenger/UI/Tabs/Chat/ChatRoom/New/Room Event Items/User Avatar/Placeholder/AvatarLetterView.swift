import SwiftUI

struct AvatarLetterView: View {
    let model: AvatarLetter

    var body: some View {
        Circle()
            .fill(model.backColor)
            .overlay(
                Text(model.letter)
                    .font(.bold(17))
                    .foregroundColor(.white)
            )
    }
}
