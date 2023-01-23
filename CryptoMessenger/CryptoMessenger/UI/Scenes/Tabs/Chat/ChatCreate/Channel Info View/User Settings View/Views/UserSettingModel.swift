import SwiftUI

struct UserSettingModel: ViewGeneratable, Hashable {
    
    let id = UUID()
    let title: String
    let titleColor: Color
    let imageName: String
    let imageColor: Color
    let accessoryImageName: String?
    let accessoryImageColor: Color?
    let onTapAction: () -> Void
    
    init(
        title: String,
        titleColor: Color,
        imageName: String,
        imageColor: Color,
        accessoryImageName: String? = nil,
        accessoryImageColor: Color? = nil,
        onTapAction: @escaping () -> Void
    ) {
        self.title = title
        self.titleColor = titleColor
        self.imageName = imageName
        self.imageColor = imageColor
        self.accessoryImageName = accessoryImageName
        self.accessoryImageColor = accessoryImageColor
        self.onTapAction = onTapAction
    }
    
    // MARK: - ViewGeneratable
    
    @ViewBuilder
    func view() -> AnyView {
        UserSettingView(model: self).anyView()
    }
}
