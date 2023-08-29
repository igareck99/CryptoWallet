import SwiftUI

struct AvatarLetter: Identifiable , ViewGeneratable {
    let id = UUID()
    let letter: String
    let backColor: Color
    
    init(
        letter: String,
        backColor: Color = .water
    ) {
        self.letter = letter
        self.backColor = backColor
    }

    // MARK: - ViewGeneratable

    func view() -> AnyView {
        AvatarLetterView(model: self).anyView()
    }
}
