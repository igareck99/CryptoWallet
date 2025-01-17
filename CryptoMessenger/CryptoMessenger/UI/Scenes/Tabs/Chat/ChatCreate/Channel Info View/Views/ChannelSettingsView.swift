import SwiftUI

// MARK: - ChannelSettingsView

struct ChannelSettingsView: View {

    // MARK: - Internal Properties

    let title: String
    let titleColor: Color
    let imageName: String
    let imageColor: Color
    let accessoryImageName: String
    let value: String

    // MARK: - Lifecycle

    init(
        title: String,
        titleColor: Color = .black,
        imageName: String,
        imageColor: Color = .azureRadianceApprox,
        accessoryImageName: String,
        value: String = ""
    ) {
        self.title = title
        self.titleColor = titleColor
        self.imageName = imageName
        self.imageColor = imageColor
        self.accessoryImageName = accessoryImageName
        self.value = value
    }

    // MARK: - Body

    var body: some View {
        HStack {
            Image(systemName: imageName)
                .foregroundColor(imageColor)
            Text(title)
                .font(.system(size: 17))
                .foregroundColor(titleColor)
            Spacer()
            if !value.isEmpty {
                Text(value)
                    .font(.regular(17))
                    .foregroundColor(.azureRadianceApprox)
            } else {
                Image(systemName: accessoryImageName)
                    .foregroundColor(.ironApprox)
            }
        }
        .background(.white())
    }
}
