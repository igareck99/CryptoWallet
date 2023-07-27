import SwiftUI

// MARK: - AvatarViewData

struct AvatarViewData: Identifiable, ViewGeneratable {

    var id = UUID()
    let avatarUrl: URL?
    let roomName: String
    let isDirect: Bool
    let isOnline: Bool

    // MARK: - ViewGeneratable

    @ViewBuilder
    func view() -> AnyView {
        AvatarView(data: self).anyView()
    }
}

// MARK: - AvatarView

struct AvatarView: View {

    let data: AvatarViewData

    var body: some View {
        ZStack {
            AsyncImage(
                defaultUrl: data.avatarUrl,
                placeholder: {
                    ZStack {
                        Color(.lightBlue())
                        Text(data.roomName.firstLetter.uppercased() ?? "?")
                            .foreground(.white)
                            .font(.system(size: 28, weight: .bold))
                    }.frame(width: 60, height: 60)
                },
                result: {
                    Image(uiImage: $0)
                }
            )
            .frame(width: 60, height: 60)
            .cornerRadius(30)
            if data.isDirect {
                ZStack {
                    Circle().fill(.white).frame(width: 16, height: 16)
                    Circle().fill( Color(data.isOnline ? .init(39, 174, 96) : .init(216, 216, 216)))
                        .frame(width: 12, height: 12)
                }.padding([.leading, .top], 48)
            }
        }.frame(width: 62, height: 62)
    }
}
