import SwiftUI

// MARK: - ChannelSettingsView

struct ChannelSettingsView: View {

    // MARK: - Internal Properties

    let title: String
    let titleColor: Color
    let imageName: String
    let image: Image?
    let imageColor: Color
    let accessoryImageName: String
    let value: String

    // MARK: - Lifecycle

    init(
        title: String,
        titleColor: Color = .chineseBlack,
        imageName: String,
        imageColor: Color = .dodgerBlue,
        accessoryImageName: String = "",
        image: Image? = nil,
        value: String = ""
    ) {
        self.title = title
        self.titleColor = titleColor
        self.imageName = imageName
        self.imageColor = imageColor
        self.accessoryImageName = accessoryImageName
        self.image = image
        self.value = value
    }

    // MARK: - Body

    var body: some View {
        HStack {
            if !imageName.isEmpty {
                Image(systemName: imageName)
                    .foregroundColor(imageColor)
                    .frame(width: 30, height: 30)
            } else {
                image?
                    .resizable()
                    .frame(width: 30, height: 30)
            }
            Text(title)
                .font(.system(size: 17))
                .foregroundColor(titleColor)
            Spacer()
            if !value.isEmpty {
                Text(value)
                    .font(.system(size: 17))
                    .foregroundColor(.dodgerBlue)
            } else {
                Image(systemName: accessoryImageName)
                    .foregroundColor(Color.ashGray)
                    .frame(width: 7.16, height: 12.3)
            }
        }
        .background(.white)
    }
}
