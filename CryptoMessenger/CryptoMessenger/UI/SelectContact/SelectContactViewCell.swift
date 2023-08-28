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
                            Color(.lightBlue())
                            Text(data.name.firstLetter.uppercased())
                                .foreground(.white())
                                .font(.medium(22))
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
                    .font(.regular(17))
                    .foreground(.black())
                Spacer()
            }
        }
        .onTapGesture {
            data.onTap(data)
        }
        .frame(height: 64)
        .background(.white())
        .padding(.horizontal, 16)
    }
}
