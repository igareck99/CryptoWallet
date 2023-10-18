import SwiftUI

// MARK: - SelectContactViewCell

struct SelectContactViewCell: View {

    // MARK: - Internal Properties

    let data: SelectContact
    
    // MARK: - Body

    var body: some View {
        HStack(alignment: .center, spacing: 12) {
            if data.isSelected {
                R.image.chat.group.check.image
                    .transition(.scale.animation(.linear(duration: 0.2)))
            } else {
                R.image.chat.group.uncheck.image
                    .transition(.opacity.animation(.linear(duration: 0.2)))
            }
            Spacer()
            HStack(spacing: 12) {
                AsyncImage(
                    defaultUrl: data.avatar,
                    placeholder: {
                        ZStack {
                            Color.aliceBlue
                            Text(data.name.firstLetter.uppercased())
                                .foreground(.white)
                                .font(.title2Bold22)
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
                    .font(.bodyRegular17)
                    .foreground(.chineseBlack)
                Spacer()
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
}
