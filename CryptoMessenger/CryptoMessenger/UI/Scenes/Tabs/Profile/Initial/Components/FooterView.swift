import SwiftUI

// MARK: - FooterView

struct FooterView: View {

    // MARK: - Internal Properties

    @Binding var popupSelected: Bool

    // MARK: - Body

    var body: some View {
        Button(action: {
//            hideTabBar()
            popupSelected.toggle()
        }, label: {
            Text(R.string.localizable.profileBuyCell())
                .frame(maxWidth: .infinity, minHeight: 44, idealHeight: 44, maxHeight: 44)
                .font(.regular(15))
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(.blue, lineWidth: 1)
                )
        })
        .frame(maxWidth: .infinity, minHeight: 44, idealHeight: 44, maxHeight: 44)
        .background(.white())
    }
}
