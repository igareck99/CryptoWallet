import SwiftUI

struct ChannelSettingsView: View {
    
    let title: String
    let titleColor: Color
    let imageName: String
    let imageColor: Color
    let accessoryImageName: String
    
    init(
        title: String,
        titleColor: Color = .black,
        imageName: String,
        imageColor: Color = .azureRadianceApprox,
        accessoryImageName: String
    ) {
        self.title = title
        self.titleColor = titleColor
        self.imageName = imageName
        self.imageColor = imageColor
        self.accessoryImageName = accessoryImageName
    }
    
    var body: some View {
        HStack {
            Image(systemName: imageName)
                .foregroundColor(imageColor)
            
            Text(title)
                .font(.system(size: 17))
                .foregroundColor(titleColor)
            
            Spacer()
            
            Image(systemName: accessoryImageName)
                .foregroundColor(.ironApprox)
        }
    }
}
