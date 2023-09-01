import SwiftUI

struct NotSentView: View {
    let model: NotSentModel
    var body: some View {
        VStack(spacing: .zero) {
            Spacer()
            Image(systemName: model.imageName)
                .frame(width: 20, height: 20)
                .foregroundColor(model.imageColor)
                .onTapGesture {
                    model.onTap()
                }
            Color.clear
                .frame(width: 20, height: model.bottomOffset)
        }
    }
}
