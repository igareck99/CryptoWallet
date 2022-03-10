import SwiftUI

// MARK: - BuyPopView

struct BuyPopView: View {

    // MARK: - Body

    var body: some View {
        VStack(alignment: .center, spacing: 12) {
            ZStack {
                Circle()
                    .fill(Color(.lightBlue()))
                    .frame(width: 80, height: 80)
                R.image.buyCellsMenu.aura.image
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
        }
    }
}

// MARK: - BuyView

struct BuyView: View {

    // MARK: - Private Properties

    @Environment(\.presentationMode) private var presentationMode

    // MARK: - Body

    var body: some View {
        ZStack {
            ZStack {
                VStack(spacing: 0) {
                    HStack(spacing: 0) {
                        Button(action: {
                            presentationMode.wrappedValue.dismiss()
                        }, label: {
                            R.image.buyCellsMenu.close.image
                        })
                            .padding([.leading, .top], 16)
                        Spacer()
                    }
                    Spacer()
                }
            }
            ZStack {
                VStack(spacing: 0) {
                    HStack(spacing: 0) {
                        Spacer()
                        Text(R.string.localizable.buyCellTitle())
                            .font(.semibold(16))
                            .padding(.top, 16)
                        Spacer()
                    }
                    Spacer()
                }
            }

            BuyPopView()
        }
    }
}
