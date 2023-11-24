import SwiftUI

// MARK: - TransactionInfoDetailView

struct TransactionInfoDetailView: View {
    
    // MARK: - Internal Properties
    
    var transaction: TransactionInfo
    let titles = ["Intiated on:", "Confirmed on:", "Paid Grom:", "Txn ID:"]
    let data = ["09.09.2020 / 15:35",
                "09.09.2020 / 16:01 (10 blocks ago) ",
                "0xaskh3qjc...a3158hadf3 ", "Oxcesar12f12eq83...f8731r12kceb"]
    
    // MARK: - Body
    
    var body: some View {
        HStack(spacing: 16) {
            VStack(alignment: .leading,
                   spacing: 2) {
                ForEach(titles, id: \.self) { item in
                    Text(item)
                        .font(.footnoteRegular13)
                }
            }
            VStack(alignment: .leading,
                   spacing: 2) {
                ForEach(data, id: \.self) { item in
                    Text(item)
                        .foregroundColor(.romanSilver)
                        .font(.subheadlineRegular15)
                }
            }
        }
    }
}
