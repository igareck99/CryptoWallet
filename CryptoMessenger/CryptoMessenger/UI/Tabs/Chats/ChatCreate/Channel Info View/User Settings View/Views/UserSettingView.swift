import SwiftUI

struct UserSettingView: View {
    
    let model: UserSettingModel
    
    var body: some View {
        HStack(alignment: .center, spacing: 8) {
            if model.image != nil {
                model.image?.resizable()
                    .frame(width: 30, height: 30, alignment: .center)
            } else {
                Image(systemName: model.imageName)
                    .foregroundColor(model.imageColor)
            }
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
        .frame(height: 57)
        .onTapGesture {
            model.onTapAction()
        }
    }
}
