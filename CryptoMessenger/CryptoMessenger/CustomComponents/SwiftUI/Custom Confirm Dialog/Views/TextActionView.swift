import SwiftUI

struct TextActionView: View {
    let model: TextActionViewModel

    var body: some View {
        Button {
            model.action()
        } label: {
            HStack(alignment: .center) {
                model.text.anyView()
                    .padding(.all, 16)
            }
        }
    }
}
