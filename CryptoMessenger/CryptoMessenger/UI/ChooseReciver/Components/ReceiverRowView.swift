import SwiftUI

// MARK: - ReceiverRowView

struct ReceiverRowView: View {

    // MARK: - Internal Properties

    let data: UserWallletData

    // MARK: - Body

    var body: some View {
        HStack(spacing: 12) {
            AsyncImage(
                defaultUrl: data.url,
                placeholder: {
                    ZStack {
                        Color(.lightBlue())
                        Text(data.name.firstLetter.uppercased())
                            .foreground(.white)
                            .font(.medium(22))
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
                    .font(.regular(17))
                Text(textDescription())
                    .foregroundColor(.gray)
                    .font(.regular(13))
            }
        }
        .background(.white())
        .onTapGesture {
            data.onTap(data)
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
            case .ethereum:
                return data.ethereum
            case .bitcoin:
                return data.bitcoin
            default:
                return ""
            }
        }
    }
}
