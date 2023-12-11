import SwiftUI

struct CallItemView: View {
    let model: CallItem
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: model.phoneImageName)
                .resizable()
                .frame(width: 44, height: 44)
                .foregroundColor(.dodgerBlue)

            VStack(alignment: .leading, spacing: 8) {
                Text(model.type.title)
                    .font(.bodyRegular17)
                    .foregroundColor(.chineseBlack)
                HStack(spacing: 8) {
                    Image(systemName: model.type.imageName)
                        .frame(width: 14, height: 14)
                        .foregroundColor(model.type.imageColor)
                    Text(model.subtitle)
                        .font(.caption1Regular12)
                        .foregroundColor(.manatee)
                }
            }
        }
        .onTapGesture {
            model.onTap()
        }
    }
}