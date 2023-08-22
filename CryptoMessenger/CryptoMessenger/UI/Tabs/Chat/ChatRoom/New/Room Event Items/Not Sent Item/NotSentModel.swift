import SwiftUI

struct NotSentModel: Identifiable, ViewGeneratable {
    let id = UUID()
    let imageName: String // system image name
    let imageColor: Color
    let onTap: () -> Void
    
    init(
        imageName: String = "exclamationmark.circle.fill",
        imageColor: Color = .spanishCrimson,
        onTap: @escaping () -> Void
    ) {
        self.imageName = imageName
        self.imageColor = imageColor
        self.onTap = onTap
    }

    // MARK: - ViewGeneratable

    func view() -> AnyView {
        NotSentView(model: self).anyView()
    }
}
