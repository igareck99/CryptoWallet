import SwiftUI

// MARK: - ReceiverRowView

struct ReceiverRowView: View {

    // MARK: - Internal Properties

    let data: UserWallletData

    // MARK: - Body

    var body: some View {
        VStack(spacing: .zero) {
            HStack(alignment: .center, spacing: 12) {
                AsyncImage(
                    defaultUrl: data.url,
                    placeholder: {
                        ZStack {
                            Color.diamond
                            Text(data.name.firstLetter.uppercased())
                                .foreground(.white)
                                .font(.title2Bold22)
                        }
                    },
                    result: {
                        Image(uiImage: $0).resizable()
                    }
                )
                .scaledToFill()
                .frame(width: 40, height: 40)
                .cornerRadius(20)
                VStack(alignment: .leading) {
                    Text(data.name)
                        .lineLimit(1)
                        .foregroundColor(.chineseBlack)
                        .font(.bodyRegular17)
                    Text(textDescription())
                        .foregroundColor(.romanSilver)
                        .font(.caption1Regular12)
                }
                Spacer()
            }
            .background(.white)
            .onTapGesture {
                data.onTap(data)
            }
        }
    }
    
    // MARK: - Private Methods
    
    private func textDescription() -> String {
        switch data.searchType {
        case .telephone:
            return data.phone
        case .wallet:
            switch data.walletType {
            case .binance:
                return data.binance
            case .ethereum, .aura:
                return data.ethereum
            case .bitcoin:
                return data.bitcoin
            default:
                return ""
            }
        }
    }
}
