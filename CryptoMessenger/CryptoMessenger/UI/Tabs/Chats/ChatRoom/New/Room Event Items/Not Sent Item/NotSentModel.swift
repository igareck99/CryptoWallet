import SwiftUI

struct NotSentModel: Identifiable, ViewGeneratable {
    let id = UUID()
    let imageName: String // system image name
    let imageColor: Color
    let bottomOffset: CGFloat
    let onTap: () -> Void

    init(
        imageName: String = "exclamationmark.circle.fill",
        imageColor: Color = .spanishCrimson,
        bottomOffset: CGFloat = .zero,
        onTap: @escaping () -> Void
    ) {
        self.imageName = imageName
        self.imageColor = imageColor
        self.bottomOffset = bottomOffset
        self.onTap = onTap
    }

    // MARK: - ViewGeneratable

    func view() -> AnyView {
        NotSentView(model: self).anyView()
    }
}
