import SwiftUI

struct TokenViewModel: ViewGeneratable {
    let id = UUID()
    let address: String
    let coinAmount: String
    let currency: String
    let onTap: () -> Void

    var value: String {
        coinAmount + " " + currency
    }

    // MARK: - ViewGeneratable

    @ViewBuilder
    func view() -> AnyView {
        TokenView(model: self).anyView()
    }
}
