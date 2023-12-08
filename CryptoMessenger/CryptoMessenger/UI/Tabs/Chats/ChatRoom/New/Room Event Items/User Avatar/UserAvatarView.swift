import SwiftUI

struct UserAvatarView<AvatarPlaceholder: View>: View {
    let model: UserAvatar
    let placeholder: AvatarPlaceholder

    var body: some View {
        VStack(spacing: .zero) {
            Spacer()
            AsyncImage(
                defaultUrl: model.avatarUrl,
                placeholder: {
                    placeholder
                },
                result: {
                    Image(uiImage: $0)
                }
            )
            .frame(width: model.size.width, height: model.size.height)
            .cornerRadius(24)
        }
        .fixedSize(horizontal: false, vertical: false)
    }
}
