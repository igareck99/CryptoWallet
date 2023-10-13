import SwiftUI

// MARK: - SelectContactViewCell

struct SelectContactViewCell: View {

    // MARK: - Internal Properties

    let data: SelectContact
    
    // MARK: - Body

    var body: some View {
        VStack {
            HStack(alignment: .center) {
                if data.isSelected {
                    R.image.chat.group.check.image
                        .transition(.scale.animation(.linear(duration: 0.2)))
                } else {
                    R.image.chat.group.uncheck.image
                        .transition(.opacity.animation(.linear(duration: 0.2)))
                }
                HStack(spacing: 10) {
                    AsyncImage(
                        defaultUrl: data.avatar,
                        placeholder: {
                            ZStack {
                                Color.aliceBlue
                                Text(data.name.firstLetter.uppercased())
                                    .foreground(.white)
                                    .font(.system(size: 22, weight: .medium))
                            }
                        },
                        result: {
                            Image(uiImage: $0).resizable()
                        }
                    )
                    .scaledToFill()
                    .frame(width: 40, height: 40)
                    .cornerRadius(20)
                    Text(data.name)
                        .lineLimit(1)
                        .font(.system(size: 17, weight: .regular))
                        .foreground(.chineseBlack)
                }
                .padding(.leading, 19)
            }
            Divider()
                .padding(.leading, 93)
        }
        .onTapGesture {
            data.onTap(data)
        }
        .frame(height: 64)
        .background(.white)
    }
}
