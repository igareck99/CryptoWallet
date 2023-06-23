import SwiftUI

struct CallActionButton: Identifiable, Hashable {

    let id = UUID()
    let text: String
    let backColor: Color
    let imageName: String
    let imageColor: Color
    let action: () -> Void
    
    init(
        text: String = "",
        backColor: Color,
        imageName: String,
        imageColor: Color,
        action: @escaping () -> Void
    ) {
        self.text = text
        self.backColor = backColor
        self.imageName = imageName
        self.imageColor = imageColor
        self.action = action
    }

    static func == (lhs: CallActionButton, rhs: CallActionButton) -> Bool {
        lhs.id == rhs.id &&
        lhs.text == rhs.text &&
        lhs.backColor == rhs.backColor &&
        lhs.imageName == rhs.imageName &&
        lhs.imageColor == rhs.imageColor
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(text)
        hasher.combine(backColor)
        hasher.combine(imageName)
        hasher.combine(imageColor)
    }
}
