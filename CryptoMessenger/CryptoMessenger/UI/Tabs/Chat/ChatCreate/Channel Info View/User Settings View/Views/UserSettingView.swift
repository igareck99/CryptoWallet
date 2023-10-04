import SwiftUI

struct UserSettingView: View {
    
    let model: UserSettingModel
    
    var body: some View {
        HStack(spacing: 0) {
            
            Image(systemName: model.imageName)
                .padding(.all, 16)
                .foregroundColor(model.imageColor)
            
            Text(model.title)
                .font(.calloutRegular16)
                .foregroundColor(model.titleColor)
            
            Spacer()
            
            if let image = model.accessoryImageName,
                let color = model.accessoryImageColor {
                Image(systemName: image)
                    .padding(.trailing, 16)
                    .foregroundColor(color)
            }
        }
        .onTapGesture {
            model.onTapAction()
        }
    }
}
