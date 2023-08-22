import SwiftUI

struct UserAvatar: Identifiable, ViewGeneratable {
    let id = UUID()
    let avatarUrl: URL?
    let size: CGSize
    let placeholder: any ViewGeneratable
    
    init(
        avatarUrl: URL? = nil,
        size: CGSize = CGSize(width: 40.0, height: 40.0),
        placeholder: any ViewGeneratable
    ) {
        self.avatarUrl = avatarUrl
        self.size = size
        self.placeholder = placeholder
    }

    // MARK: - ViewGeneratable

    func view() -> AnyView {
        UserAvatarView(model: self, placeholder: placeholder.view()).anyView()
    }
}
