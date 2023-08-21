import SwiftUI

// MARK: - ChatCreateContactsErrorView

struct ChatCreateContactsErrorView: View {

    // MARK: - Body

    var body: some View {
        VStack(alignment: .center) {
            Spacer()
            Text(R.string.localizable.chatContactEror())
                .multilineTextAlignment(.center)
                .font(.system(size: 15, weight: .regular))
                .foregroundColor(.chineseBlack)
                .padding(.init(top: 8, leading: 16, bottom: 16, trailing: 16))
            Button(action: {
                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
            }, label: {
                Text(R.string.localizable.chatOpenSettings())
                    .frame(maxWidth: .infinity, minHeight: 44, idealHeight: 44, maxHeight: 44)
                    .font(.system(size: 15, weight: .regular))
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.dodgerBlue, lineWidth: 1)
                    )
            })
                .frame(maxWidth: .infinity, minHeight: 44, idealHeight: 44, maxHeight: 44)
                .background(.white)
                .padding(.horizontal, 16)
            Spacer()
        }
    }
}
