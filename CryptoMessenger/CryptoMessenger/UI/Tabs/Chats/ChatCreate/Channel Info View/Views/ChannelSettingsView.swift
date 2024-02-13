import SwiftUI

// MARK: - ChannelSettingsView

struct ChannelSettingsView: View {

    // MARK: - Internal Properties

    let title: String
    let titleColor: Color
    let imageName: String
    let image: Image?
    let imageColor: Color
    let accessoryImage: Image?
    let accessoryImageName: String
    let value: String

    // MARK: - Lifecycle

    init(
        title: String,
        titleColor: Color = .chineseBlack,
        imageName: String = "",
        imageColor: Color = .dodgerBlue,
        accessoryImageName: String = "",
        image: Image? = nil,
        accessoryImage: Image? = nil,
        value: String = ""
    ) {
        self.title = title
        self.titleColor = titleColor
        self.imageName = imageName
        self.imageColor = imageColor
        self.accessoryImageName = accessoryImageName
        self.image = image
        self.accessoryImage = accessoryImage
        self.value = value
    }

    // MARK: - Body

    var body: some View {
        HStack(alignment: .center) {
            if !imageName.isEmpty {
                Image(systemName: imageName)
                    .foregroundColor(imageColor)
            } else {
                image?
                    .resizable()
                    .frame(width: 30, height: 30)
            }
            Text(title)
                .font(.bodyRegular17)
                .foregroundColor(titleColor)
            Spacer()
            if !value.isEmpty {
                Text(value)
                    .font(.bodyRegular17)
                    .foregroundColor(.dodgerBlue)
            } else {
                accessoryImage
                    .frame(width: 7.16, height: 12.3)
            }
        }
        .background(.white)
    }
}
