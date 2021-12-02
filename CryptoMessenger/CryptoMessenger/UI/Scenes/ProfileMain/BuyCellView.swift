import SwiftUI

// MARK: - BuyPopView

struct BuyPopView: View {

    // MARK: - Body

    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .center,
                   spacing: 12) {
                ZStack {
                    Image(uiImage: UIImage())
                        .frame(width: 80, height: 80)
                        .background(.lightBlue())
                        .clipShape(Circle())
                    Image(uiImage: R.image.buyCellsMenu.aura() ?? UIImage())
                        .background(.lightBlue())
                        .frame(width: 45, height: 45)
                }
                Text("250.41 AUR")
                    .padding(.top, 4)
                    .font(.regular(32))
                Text(R.string.localizable.buyCellYourBalance())
                    .font(.regular(15))
                    .foreground(.darkGray())
                Button(R.string.localizable.profileBuyCell()) {
                }
                .frame(width: 251, height: 44, alignment: .center)
                    .font(.bold(15))
                    .background(.blue())
                    .foreground(.white())
                    .cornerRadius(8)
            }.padding(.leading, (geometry.size.width - 251) / 2)
        }
    }
}

// MARK: - BuyCellView

struct BuyCellView: View {

    // MARK: - Internal Properties

    @State var showingPopup: Bool

    // MARK: - Private Properties

    @Environment(\.presentationMode) private var presentationMode

    // MARK: - Body

    var body: some View {
        GeometryReader { geometry in
            ZStack {
            VStack(alignment: .leading, spacing: 48) {
                HStack(spacing: 90) {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }, label: {
                        Image(uiImage: R.image.buyCellsMenu.close() ?? UIImage())
                            .frame(width: 24, height: 24)
                            .padding(.leading, 24)
                    })
                    Text(R.string.localizable.buyCellTitle())
                        .font(.semibold(16))
                }.padding(.trailing, -geometry.size.width * 0.5 + 32)
                BuyPopView()
            }
            }
        }.background(.white())
    }
}

// MARK: - BuyCellView_Preview

struct BuyCellViewPreview: PreviewProvider {
    static var previews: some View {
        BuyCellView(showingPopup: false)
    }
}
