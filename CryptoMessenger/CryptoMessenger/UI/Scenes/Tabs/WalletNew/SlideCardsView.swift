import SwiftUI

// MARK: - RewardsView

struct CardImageView: View {
    
    // MARK: - Internal Properties

    let image: Image
    
    // MARK: - Body

    var body: some View {
        image
            .resizable()
            .scaledToFill()
    }
}

// MARK: - CardNewView

struct CardNewView: View {

    // MARK: - Internal Properties

    let wallet: WalletInfo
    let image = UIImage(systemName: "exclamationmark.circle")?.tintColor(.white())

    // MARK: - Body

    var body: some View {
        switch wallet.walletType {
        case .aur:
            VStack(alignment: .leading) {
                CardImageView(image: wallet.result.image)
            }
        case .ethereum:
            ZStack {
                CardImageView(image: wallet.result.image)
                VStack(alignment: .leading) {
                    HStack(alignment: .top ) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text(String(wallet.coinAmount) + " \(wallet.result.currency)")
                                .font(.regular(22))
                                .foreground(.white())
                            Text(String(wallet.result.fiatAmount) + " USD")
                                .font(.regular(12))
                                .foreground(.white(0.4))
                        }
                        .padding(.leading, 20)
                        Spacer()
                        Button {
                        } label: {
                            ZStack {
                                Circle()
                                    .frame(width: 36, height: 36)
                                    .foreground(.gray335664())
                                R.image.wallet.plus.image
                            }
                        }
                        .padding(.trailing, 14)
                    }
                    .padding(.top, 20)
                    Spacer()
                    HStack {
                        Text("")
                            .padding(.leading, 20)
                        Spacer()
                        HStack(spacing: 10) {
                            Text(wallet.adress)
                                .font(.regular(16))
                                .foreground(.white())
                            Image(uiImage: image ?? UIImage())
                                .frame(width: 30,
                                       height: 30)
                        }
                        .padding(.trailing, 16)
                    }
                    .padding(.bottom, 19)
                }
            }
        case .bitcoin:
            VStack(alignment: .leading) {
                CardImageView(image: wallet.result.image)
            }
        }
    }
}

// MARK: - RewardsView

struct SlideCardsView: View {

    // MARK: - Internal Properties

    @Binding var offset: CGFloat
    @Binding var index: Int
    @StateObject var viewModel: WalletNewViewModel
    let spacing: CGFloat = 8

    // MARK: - Body

    var body: some View {
        GeometryReader { geometry in
            ScrollView(.horizontal, showsIndicators: true) {
                HStack(spacing: self.spacing) {
                    ForEach(self.viewModel.cardsList) { wallet in
                        CardNewView(wallet: wallet)
                            .frame(width: geometry.size.width,
                                   height: 193)
                    }
                }
            }
            .content.offset(x: self.offset)
            .frame(width: geometry.size.width, alignment: .leading)
            .gesture(
                DragGesture()
                    .onChanged({ value in
                        self.offset = value.translation.width - geometry.size.width * CGFloat(self.index)
                    })
                    .onEnded({ value in
                        if -value.predictedEndTranslation.width > geometry.size.width / 2, self.index < self.viewModel.cardsList.count - 1 {
                            self.index += 1
                            print("dodkmeod   \(Double(self.index) / Double(viewModel.cardsList.count))")
                        }
                        if value.predictedEndTranslation.width > geometry.size.width / 2, self.index > 0 {
                            self.index -= 1
                        }
                        withAnimation { self.offset = -(geometry.size.width + self.spacing) * CGFloat(self.index) }
                    })
            )
        }
    }
}
